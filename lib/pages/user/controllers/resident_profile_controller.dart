import 'package:get/get.dart';
import '../views/guestbook_view.dart';

class ResidentProfileController extends GetxController {
  final String villageName;
  late String residentName;

  ResidentProfileController({
    required this.villageName,
    this.residentName = '주민',
  });

  // 뒤로가기
  void goBack() {
    Get.back();
  }

  // 방명록 가기
  void goToGuestbook() {
    Get.to(() => GuestbookScreen(residentName: residentName));
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
