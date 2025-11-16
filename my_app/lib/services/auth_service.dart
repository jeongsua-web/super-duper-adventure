import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // User state stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign up with email and password
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'message': '회원가입 성공'};
    } on FirebaseAuthException catch (e) {
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
    } on FirebaseAuthException catch (e) {
      debugPrint('SignIn error: ${e.message}');
      return false;
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('SignOut error: ${e.message}');
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
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