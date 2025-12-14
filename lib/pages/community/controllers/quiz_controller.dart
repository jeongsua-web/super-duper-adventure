import 'package:get/get.dart';

class QuizController extends GetxController {
  final String villageName;
  final String villageId;

  QuizController({
    required this.villageName,
    required this.villageId,
  });

  // 임시 퀴즈 데이터
  final RxList<Map<String, dynamic>> activeQuizzes = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': '고양이 이름이 뭘까',
      'description': '사진 속 아련하게 쳐다보는\n고양이의 이름을 맞쳐보렴',
      'isActive': true,
    },
  ].obs;

  final RxList<Map<String, dynamic>> completedQuizzes = <Map<String, dynamic>>[
    {'id': '2', 'title': '퀴즈 제목', 'date': '2034.2.12', 'isActive': false},
    {'id': '3', 'title': '퀴즈 제목', 'date': '2034.2.12', 'isActive': false},
    {'id': '4', 'title': '퀴즈 제목', 'date': '2034.2.12', 'isActive': false},
    {'id': '5', 'title': '퀴즈 제목', 'date': '2034.2.12', 'isActive': false},
  ].obs;

  void goToMainHome() {
    Get.offAllNamed('/main-home');
  }

  void goToVillageView() {
    Get.toNamed('/village-view', arguments: {'villageName': villageName});
  }

  void startQuiz(String quizId) {
    Get.snackbar('퀴즈 시작', '퀴즈 ID: $quizId');
    // TODO: 실제 퀴즈 화면으로 이동
  }

  void viewQuizResult(String quizId) {
    Get.snackbar('퀴즈 결과', '퀴즈 ID: $quizId');
    // TODO: 퀴즈 결과 화면으로 이동
  }
}
