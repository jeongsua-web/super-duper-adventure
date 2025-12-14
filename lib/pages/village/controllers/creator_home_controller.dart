import 'package:get/get.dart';

class CreatorHomeController extends GetxController {
  final String villageName;

  CreatorHomeController({required this.villageName});

  void goBack() {
    Get.back();
  }

  void showMemberRankings() {
    Get.snackbar('전체 주민 친밀도 순위', '준비 중입니다.');
  }

  void showQuizAnswers() {
    Get.snackbar('역대 퀴즈 정답', '준비 중입니다.');
  }
}
