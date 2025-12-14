import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_routes.dart';

class AccountSettingsController extends GetxController {
  // 반응형 변수
  final RxBool notificationEnabled = true.obs;
  final RxBool darkModeEnabled = false.obs;
  final RxBool animationEnabled = true.obs;
  final RxDouble fontSize = 1.0.obs;
  
  // 로그아웃
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        '로그아웃 실패',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // 비밀번호 변경
  void changePassword() {
    Get.snackbar(
      '준비 중',
      '비밀번호 변경 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // 닉네임 변경
  void changeNickname() {
    Get.snackbar(
      '준비 중',
      '닉네임 변경 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // 계정 전환
  void switchAccount() {
    Get.snackbar(
      '준비 중',
      '계정 전환 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // 알림 토글
  void toggleNotification() {
    notificationEnabled.value = !notificationEnabled.value;
    Get.snackbar(
      '알림 설정',
      notificationEnabled.value ? '알림이 켜졌습니다' : '알림이 꺼졌습니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
  
  // 세부 알림 설정
  void configureDetailedNotification() {
    Get.snackbar(
      '준비 중',
      '세부 알림 설정 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // 다크모드 토글
  void toggleDarkMode() {
    darkModeEnabled.value = !darkModeEnabled.value;
    Get.snackbar(
      '다크모드',
      darkModeEnabled.value ? '다크모드가 켜졌습니다' : '다크모드가 꺼졌습니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
  
  // 글꼴 크기 조정
  void adjustFontSize() {
    Get.snackbar(
      '준비 중',
      '글꼴 크기 조정 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // 애니메이션 토글
  void toggleAnimation() {
    animationEnabled.value = !animationEnabled.value;
    Get.snackbar(
      '애니메이션',
      animationEnabled.value ? '애니메이션이 켜졌습니다' : '애니메이션이 꺼졌습니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
  
  // 회원 탈퇴
  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('정말 탈퇴하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                // TODO: 탈퇴 로직 구현
                await FirebaseAuth.instance.currentUser?.delete();
                Get.offAllNamed(AppRoutes.login);
                Get.snackbar(
                  '탈퇴 완료',
                  '회원 탈퇴가 완료되었습니다',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar(
                  '탈퇴 실패',
                  '$e',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('탈퇴', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  // 뒤로가기
  void goBack() {
    Get.back();
  }
}
