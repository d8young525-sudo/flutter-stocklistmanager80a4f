import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  Timer? _sessionTimer;
  String? _currentSessionId;
  Function()? onSessionInvalidated;

  /// 세션 검증 시작 (5초마다 자동 확인)
  void startValidation() {
    stopValidation(); // 기존 타이머 중지

    _sessionTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _validateSession();
    });
  }

  /// 세션 검증 중지
  void stopValidation() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// Firebase에서 세션 검증 (users 컬렉션의 sessionToken 사용)
  Future<void> _validateSession() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (kDebugMode) print('⚠️ 사용자 로그아웃 상태, 검증 중지');
        stopValidation();
        return;
      }

      if (kDebugMode) print('🔍 세션 검증 중... UID: ${user.uid}');

      // Firestore users 컬렉션에서 sessionToken 조회
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        if (kDebugMode) print('⚠️ 사용자 문서 없음');
        stopValidation();
        onSessionInvalidated?.call();
        return;
      }

      final userData = userDoc.data();
      if (userData == null) {
        if (kDebugMode) print('⚠️ 사용자 데이터 없음');
        return;
      }

      final String? serverSessionToken = userData['sessionToken'];
      
      if (serverSessionToken == null) {
        if (kDebugMode) print('⚠️ 서버 세션 토큰 없음');
        return;
      }

      // 첫 검증 시 현재 세션 ID 저장
      if (_currentSessionId == null) {
        _currentSessionId = serverSessionToken;
        if (kDebugMode) print('✅ 현재 세션 ID 저장: ${serverSessionToken.substring(0, 10)}...');
        return;
      }

      // 세션 토큰이 변경되었는지 확인 (다른 기기에서 로그인)
      if (serverSessionToken != _currentSessionId) {
        if (kDebugMode) {
          print('🚨 다른 기기 로그인 감지!');
          print('   로컬 세션: ${_currentSessionId!.substring(0, 10)}...');
          print('   서버 세션: ${serverSessionToken.substring(0, 10)}...');
        }
        
        // 세션 무효 콜백 실행
        stopValidation();
        onSessionInvalidated?.call();
        return;
      }

      if (kDebugMode) print('✅ 세션 검증 통과');
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ 세션 검증 오류: $e');
      }
    }
  }

  /// 세션 ID 업데이트 (로그인 시 호출)
  Future<void> updateSession(String sessionToken) async {
    _currentSessionId = sessionToken;
    if (kDebugMode) {
      print('✅ SessionService: 로컬 세션 ID 업데이트');
      print('   세션 토큰: ${sessionToken.substring(0, 10)}...');
    }
  }

  /// 세션 삭제 (로그아웃 시 호출)
  Future<void> clearSession() async {
    stopValidation();
    _currentSessionId = null;
    if (kDebugMode) {
      print('✅ SessionService: 로컬 세션 삭제 완료');
    }
  }
}
