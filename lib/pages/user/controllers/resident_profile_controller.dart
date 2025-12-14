import 'package:get/get.dart';
import '../views/guestbook_view.dart';

class ResidentProfileController extends GetxController {
  final String villageName;

  ResidentProfileController({required this.villageName});

  // 뒤로가기
  void goBack() {
    Get.back();
  }

  // 방명록 가기
  void goToGuestbook() {
    Get.to(() => GuestbookScreen(residentName: villageName));
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
