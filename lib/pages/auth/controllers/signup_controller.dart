import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class SignupController extends GetxController {
  // TextEditingControllers
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phone1Controller = TextEditingController();
  final phone2Controller = TextEditingController();
  final emailLocalController = TextEditingController();
  final emailDomainController = TextEditingController();

  // AuthService
  final AuthService _authService = AuthService();

  // 반응형 변수
  final RxString selectedPhonePrefix = '010'.obs;
  final RxString selectedEmailDomain = 'naver.com'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    emailLocalController.dispose();
    emailDomainController.dispose();
    super.onClose();
  }

  // 이메일 도메인 선택 변경
  void updateEmailDomain(String newDomain) {
    selectedEmailDomain.value = newDomain;
    if (newDomain == '직접입력') {
      emailDomainController.clear();
    } else {
      emailDomainController.text = newDomain;
    }
  }

  // 전화번호 앞자리 변경
  void updatePhonePrefix(String newPrefix) {
    selectedPhonePrefix.value = newPrefix;
  }

  // 회원가입 처리
  Future<void> handleSignup() async {
    // 입력값 검증
    if (nameController.text.isEmpty ||
        phone1Controller.text.isEmpty ||
        phone2Controller.text.isEmpty ||
        emailLocalController.text.isEmpty) {
      Get.snackbar(
        '입력 오류',
        '모든 필수 필드를 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 이메일 조합
    final emailDomain = selectedEmailDomain.value == '직접입력'
        ? emailDomainController.text
        : selectedEmailDomain.value;
    final fullEmail = '${emailLocalController.text}@$emailDomain';

    if (emailDomain.isEmpty) {
      Get.snackbar(
        '입력 오류',
        '이메일 도메인을 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        '입력 오류',
        '비밀번호를 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Firebase 회원가입
      final result = await _authService.signUp(
        fullEmail,
        passwordController.text,
      );

      Get.snackbar(
        result['success'] ? '회원가입 성공' : '회원가입 실패',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
      );

      if (result['success']) {
        // 로그인 화면으로 이동
        Get.back();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 뒤로가기
  void goBack() {
    Get.back();
  }
}
