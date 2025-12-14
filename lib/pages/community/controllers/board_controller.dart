import 'package:get/get.dart';

class BoardController extends GetxController {
  final String villageName;
  final String villageId;

  BoardController({
    required this.villageName,
    required this.villageId,
  });

  final RxString selectedCategory = '전체'.obs;
  final List<String> categories = ['전체', '일상', '게임', '취미', '퀴즈'];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void goToMainHome() {
    Get.offAllNamed('/main-home');
  }

  void goToVillageView() {
    Get.toNamed('/village-view', arguments: {'villageName': villageName});
  }

  void goToBoardList(String category) {
    Get.toNamed('/board-list', arguments: {
      'category': category,
      'villageName': villageName,
      'villageId': villageId,
    });
  }

  void goToQuiz() {
    Get.toNamed('/quiz', arguments: {
      'villageName': villageName,
      'villageId': villageId,
    });
  }
}
