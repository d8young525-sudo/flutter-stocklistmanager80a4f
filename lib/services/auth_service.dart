import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'session_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 사용자 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 현재 사용자
  User? get currentUser => _auth.currentUser;

  // 회원가입
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // 비밀번호 길이 검증 (최소 6글자 - Firebase 정책)
      if (password.length < 6) {
        return {
          'success': false,
          'message': '비밀번호는 최소 6글자 이상이어야 합니다.',
        };
      }

      // 이메일 형식 검증
      if (!email.contains('@')) {
        return {
          'success': false,
          'message': '올바른 이메일 형식이 아닙니다.',
        };
      }

      // Firebase Authentication 회원가입
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 사용자 정보 저장 (approved: false로 초기 설정)
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'approved': false, // 관리자 승인 대기 상태
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 자동 로그아웃 (승인 전까지 로그인 불가)
      await _auth.signOut();

      return {
        'success': true,
        'message': '회원가입이 완료되었습니다. 관리자 승인 후 로그인할 수 있습니다.',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = '이미 사용 중인 이메일입니다.';
          break;
        case 'invalid-email':
          message = '올바른 이메일 형식이 아닙니다.';
          break;
        case 'weak-password':
          message = '비밀번호가 너무 약합니다. 최소 6글자 이상 입력해주세요.';
          break;
        default:
          message = '회원가입 중 오류가 발생했습니다: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': '회원가입 중 오류가 발생했습니다: $e',
      };
    }
  }

  // 로그인
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authentication 로그인
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Firestore에서 사용자 승인 상태 확인
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        await _auth.signOut();
        return {
          'success': false,
          'message': '사용자 정보를 찾을 수 없습니다.',
        };
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      bool isApproved = userData['approved'] ?? false;

      if (!isApproved) {
        await _auth.signOut();
        return {
          'success': false,
          'message': '관리자 승인 대기 중입니다. 승인 후 로그인해 주세요.',
        };
      }

      // ✅ 간단한 세션 토큰 방식
      // 새로운 세션 토큰 생성 (타임스탬프)
      String sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
      
      // ignore: avoid_print
      print('🔐 [로그인] 세션 토큰 생성: ${sessionToken.substring(0, 10)}...');
      // ignore: avoid_print
      print('🔐 [로그인] UID: ${uid.substring(0, 8)}...');
      
      // SharedPreferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token_$uid', sessionToken);
      // ignore: avoid_print
      print('✅ [로그인] 로컬 저장 완료');
      
      // Firestore에 저장 (기존 세션 자동 덮어쓰기)
      await _firestore.collection('users').doc(uid).update({
        'sessionToken': sessionToken,
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      // ignore: avoid_print
      print('✅ [로그인] Firestore 업데이트 완료');

      // 🔥 SessionService 업데이트 (다중 세션 방지용)
      await SessionService().updateSession(sessionToken);
      // ignore: avoid_print
      print('✅ [로그인] SessionService 업데이트 완료');

      return {
        'success': true,
        'message': '로그인 성공',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = '등록되지 않은 이메일입니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 일치하지 않습니다.';
          break;
        case 'invalid-email':
          message = '올바른 이메일 형식이 아닙니다.';
          break;
        case 'user-disabled':
          message = '비활성화된 계정입니다.';
          break;
        case 'too-many-requests':
          message = '로그인 시도가 너무 많습니다. 잠시 후 다시 시도해주세요.';
          break;
        default:
          message = '로그인 중 오류가 발생했습니다: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': '로그인 중 오류가 발생했습니다: $e',
      };
    }
  }

  // 로그아웃 (간단 버전)
  Future<void> signOut() async {
    try {
      User? user = _auth.currentUser;
      
      if (user == null) {
        // ignore: avoid_print
        print('⚠️ 이미 로그아웃 상태');
        return;
      }
      
      String uid = user.uid;
      
      // ignore: avoid_print
      print('🚪 로그아웃 실행...');
      
      // 로컬 세션 토큰만 삭제
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_token_$uid');
      
      // 🔥 SessionService 세션 삭제
      await SessionService().clearSession();
      
      // Firebase Auth 로그아웃
      await _auth.signOut();
      
      // ignore: avoid_print
      print('✅ 로그아웃 완료!');
    } catch (e) {
      // ignore: avoid_print
      print('❌ 로그아웃 에러: $e');
    }
  }

  // ✅ 세션 토큰 검증 (간단하고 확실함!)
  Future<bool> validateSessionToken() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;
      
      String uid = user.uid;
      
      // 1. 로컬 세션 토큰 가져오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? localToken = prefs.getString('session_token_$uid');
      
      if (localToken == null) {
        // ignore: avoid_print
        print('⚠️ 로컬 세션 토큰 없음');
        return false;
      }
      
      // 2. Firestore에서 세션 토큰 가져오기
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        // ignore: avoid_print
        print('⚠️ Firestore 사용자 문서 없음');
        return false;
      }
      
      String? serverToken = (doc.data() as Map<String, dynamic>?)?['sessionToken'];
      
      if (serverToken == null) {
        // ignore: avoid_print
        print('⚠️ Firestore 세션 토큰 없음');
        return false;
      }
      
      // 3. 토큰 비교
      bool isValid = localToken == serverToken;
      
      if (!isValid) {
        // ignore: avoid_print
        print('🚨 세션 토큰 불일치!');
        print('   로컬: ${localToken.substring(0, 10)}...');
        print('   서버: ${serverToken.substring(0, 10)}...');
      }
      
      return isValid;
      
    } catch (e) {
      // ignore: avoid_print
      print('❌ 세션 검증 에러: $e');
      return false;
    }
  }

  // 사용자 승인 상태 확인
  Future<bool> checkApprovalStatus(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['approved'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 사용자 승인 (관리자용)
  Future<void> approveUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'approved': true,
        'approvedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('사용자 승인 중 오류가 발생했습니다: $e');
    }
  }

  // 사용자 승인 취소 (관리자용)
  Future<void> revokeApproval(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'approved': false,
        'sessionToken': FieldValue.delete(), // 세션 토큰 삭제로 강제 로그아웃
      });
    } catch (e) {
      throw Exception('사용자 승인 취소 중 오류가 발생했습니다: $e');
    }
  }

  // 비밀번호 재설정 이메일 전송
  Future<Map<String, dynamic>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      // 이메일 형식 검증
      if (!email.contains('@')) {
        return {
          'success': false,
          'message': '올바른 이메일 형식이 아닙니다.',
        };
      }

      // Firebase Authentication 비밀번호 재설정 이메일 전송
      await _auth.sendPasswordResetEmail(email: email);

      return {
        'success': true,
        'message': '비밀번호 재설정 링크가 이메일로 전송되었습니다.\n이메일을 확인해주세요.',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = '등록되지 않은 이메일입니다.';
          break;
        case 'invalid-email':
          message = '올바른 이메일 형식이 아닙니다.';
          break;
        case 'too-many-requests':
          message = '요청이 너무 많습니다. 잠시 후 다시 시도해주세요.';
          break;
        default:
          message = '비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': '비밀번호 재설정 이메일 전송 중 오류가 발생했습니다: $e',
      };
    }
  }
}
