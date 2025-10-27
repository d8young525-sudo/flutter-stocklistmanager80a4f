import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  /// Firebase에서 세션 검증
  Future<void> _validateSession() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // 사용자가 로그아웃된 경우
        stopValidation();
        return;
      }

      // Firestore에서 사용자 세션 정보 조회
      final sessionDoc = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(user.uid)
          .get();

      if (!sessionDoc.exists) {
        // 세션 정보가 없는 경우 (최초 로그인 또는 세션 만료)
        return;
      }

      final sessionData = sessionDoc.data();
      if (sessionData == null) return;

      final String? firestoreSessionId = sessionData['sessionId'];
      final Timestamp? lastActive = sessionData['lastActive'];

      // 첫 검증 시 현재 세션 ID 저장
      _currentSessionId ??= firestoreSessionId;

      // 세션 ID가 변경되었는지 확인 (다른 기기에서 로그인)
      if (firestoreSessionId != _currentSessionId) {
        if (kDebugMode) {
          print('🚨 다른 기기 로그인 감지! 세션 무효화');
        }
        
        // 세션 무효 콜백 실행
        stopValidation();
        onSessionInvalidated?.call();
        return;
      }

      // 세션이 너무 오래된 경우 (30분 이상)
      if (lastActive != null) {
        final lastActiveTime = lastActive.toDate();
        final now = DateTime.now();
        final difference = now.difference(lastActiveTime);

        if (difference.inMinutes > 30) {
          if (kDebugMode) {
            print('⏰ 세션 만료 (30분 이상 비활성)');
          }
          
          stopValidation();
          onSessionInvalidated?.call();
          return;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 세션 검증 오류: $e');
      }
    }
  }

  /// 세션 ID 업데이트 (로그인 시 호출)
  Future<void> updateSession(String sessionId) async {
    _currentSessionId = sessionId;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('sessions').doc(user.uid).set({
        'sessionId': sessionId,
        'lastActive': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'email': user.email,
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ 세션 업데이트 오류: $e');
      }
    }
  }

  /// 세션 삭제 (로그아웃 시 호출)
  Future<void> clearSession() async {
    stopValidation();
    _currentSessionId = null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('sessions').doc(user.uid).delete();
    } catch (e) {
      if (kDebugMode) {
        print('❌ 세션 삭제 오류: $e');
      }
    }
  }
}

// Debug mode check (Flutter Foundation에서 제공)
bool get kDebugMode {
  bool debugMode = false;
  assert(() {
    debugMode = true;
    return true;
  }());
  return debugMode;
}
