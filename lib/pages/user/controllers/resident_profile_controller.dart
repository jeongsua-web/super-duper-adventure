import 'package:get/get.dart';

class ResidentProfileController extends GetxController {
  final String villageName;

  ResidentProfileController({required this.villageName});

  // 뒤로가기
  void goBack() {
    Get.back();
  }

  // 방명록 가기
  void goToGuestbook() {
    // TODO: Implement guestbook navigation
    Get.snackbar(
      '방명록',
      '방명록 기능 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // 스티커 붙이기
  void attachSticker() {
    Get.snackbar(
      '스티커',
      '스티커 붙히기',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
