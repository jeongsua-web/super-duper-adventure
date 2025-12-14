import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../routes/app_routes.dart';
import '../../../services/storage_service.dart';

class LoginController extends GetxController {
  // TextEditingController
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 반응형 변수
  final RxBool savePassword = false.obs;
  final RxBool isLoading = false.obs;

  // 서비스
  late final StorageService _storage;

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<StorageService>();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // 이메일/비밀번호 로그인
  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        '입력 오류',
        '이메일과 비밀번호를 입력하세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // UserController를 통해 토큰 저장 및 사용자 정보 설정
        await _storage.saveString('uToken', userCredential.user!.uid);

        // UserController의 user 업데이트는 자동으로 Firebase Auth 리스너가 처리
        Get.offAllNamed(AppRoutes.mainHome);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = '존재하지 않는 계정입니다';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호가 틀렸습니다';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다';
      } else if (e.code == 'invalid-credential') {
        message = '이메일 또는 비밀번호가 올바르지 않습니다';
      } else {
        message = '로그인 실패: ${e.message}';
      }

      Get.snackbar('로그인 실패', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('오류 발생', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Google 로그인
  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;

      if (kIsWeb) {
        // Web에서는 signInWithPopup 사용
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // 모바일에서는 Google Sign-In 패키지 사용
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          isLoading.value = false;
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      Get.offAllNamed(AppRoutes.mainHome);
    } catch (e) {
      print('Google 로그인 에러: $e');
      Get.snackbar('Google 로그인 실패', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Apple 로그인
  Future<void> handleAppleSignIn() async {
    try {
      isLoading.value = true;

      if (kIsWeb) {
        // Web에서는 signInWithPopup 사용
        OAuthProvider appleProvider = OAuthProvider('apple.com');
        appleProvider.addScope('email');
        appleProvider.addScope('name');
        await FirebaseAuth.instance.signInWithPopup(appleProvider);
      } else {
        // 모바일에서는 Sign In with Apple 패키지 사용
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oauthCredential = OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      }

      Get.offAllNamed(AppRoutes.mainHome);
    } catch (e) {
      print('Apple 로그인 에러: $e');
      Get.snackbar('Apple 로그인 실패', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // 회원가입 화면으로 이동
  void navigateToSignUp() {
    Get.toNamed(AppRoutes.signup);
  }

  // 비밀번호 저장 토글
  void toggleSavePassword() {
    savePassword.value = !savePassword.value;
  }

  // 아이디/비밀번호 찾기 (추후 구현)
  void handleFindAccount() {
    Get.snackbar(
      '준비 중',
      '아이디/비밀번호 찾기 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
