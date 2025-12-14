import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';

class SignupController extends GetxController {
  // TextEditingControllers
  final usernameController = TextEditingController();  // 아이디
  final nameController = TextEditingController();      // 실명
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
  
  // 성별 선택
  final RxString selectedGender = ''.obs;
  
  // 직업 선택
  final RxString selectedJob = ''.obs;
  final TextEditingController customJobController = TextEditingController();

  @override
  void onClose() {
    usernameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    emailLocalController.dispose();
    emailDomainController.dispose();
    customJobController.dispose();
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
  
  // 성별 선택
  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  
  // 직업 선택
  void selectJob(String job) {
    selectedJob.value = job;
    if (job != '직접입력') {
      customJobController.clear();
    }
  }

  // 회원가입 처리
  Future<void> handleSignup() async {
    // 입력값 검증
    if (usernameController.text.isEmpty ||
        nameController.text.isEmpty ||
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

      if (result['success']) {
        // Firestore에 사용자 정보 저장
        final userId = _authService.currentUser?.uid;
        if (userId != null) {
          // 성별 정보 처리
          String? genderValue;
          if (selectedGender.value == '저는 남자에요') {
            genderValue = '남자';
          } else if (selectedGender.value == '저는 여자에요') {
            genderValue = '여자';
          } else if (selectedGender.value == '중성이에요') {
            genderValue = '중성';
          } else if (selectedGender.value == '아직 잘 모르겠는데요') {
            genderValue = null;
          }

          // 직업 정보 처리
          final jobValue = selectedJob.value == '직접입력'
              ? customJobController.text
              : selectedJob.value;

          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'id': userId,
            'username': usernameController.text,
            'name': nameController.text,  // 기존 name 필드 유지
            'realName': nameController.text,  // 실명
            'email': fullEmail,
            'phone': '${selectedPhonePrefix.value}-${phone1Controller.text}-${phone2Controller.text}',
            'gender': genderValue,
            'job': jobValue.isNotEmpty ? jobValue : null,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        Get.snackbar(
          '회원가입 성공',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );

        // 로그인 화면으로 이동
        Get.back();
      } else {
        Get.snackbar(
          '회원가입 실패',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
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
