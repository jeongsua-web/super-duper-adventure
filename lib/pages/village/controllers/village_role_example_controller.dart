import 'package:get/get.dart';

class VillageRoleExampleController extends GetxController {
  final String villageId;

  VillageRoleExampleController({required this.villageId});

  void showRoleInfo(String title, String message) {
    Get.snackbar(title, message);
  }

  void goBack() {
    Get.back();
  }
}
