import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as models;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Get current user
  auth.User? get currentUser => _firebaseAuth.currentUser;

  // User state stream
  Stream<auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Login with email and password - User 모델 반환
  Future<models.User?> login(String email, String password) async {
    try {
      // Firebase Auth 로그인
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      // Firestore에서 유저 데이터 가져오기
      return await getUserData(userCredential.user!.uid);
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Login unexpected error: $e');
      return null;
    }
  }

  /// Get user data from Firestore by UID
  Future<models.User?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        // 유저 데이터가 없으면 기본값으로 생성 (옵션)
        debugPrint('User data not found for uid: $uid');
        
        // 임시 더미 데이터 반환 (실제로는 DB에 저장 후 가져와야 함)
        final email = _firebaseAuth.currentUser?.email ?? 'unknown@email.com';
        return models.User(
          id: uid,
          name: email.split('@')[0],
          email: email,
        );
      }

      return models.User.fromJson({
        'id': uid,
        ...doc.data()!,
      });
    } catch (e) {
      debugPrint('getUserData error: $e');
      return null;
    }
  }

  /// Sign up with email and password
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'message': '회원가입 성공'};
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('SignUp error: ${e.code} - ${e.message}');
      String message;
      if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다. 6자 이상 입력하세요';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 사용 중인 이메일입니다';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다';
      } else {
        message = '회원가입 실패: ${e.message}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      debugPrint('SignUp unexpected error: $e');
      return {'success': false, 'message': '알 수 없는 오류: $e'};
    }
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('SignIn error: ${e.message}');
      return false;
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('SignOut error: ${e.message}');
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('Reset password error: ${e.message}');
      return false;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// Get user email
  String? getUserEmail() {
    return _firebaseAuth.currentUser?.email;
  }
}