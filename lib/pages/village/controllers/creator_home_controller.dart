import 'package:get/get.dart';

class CreatorHomeController extends GetxController {
  final String villageName;

  CreatorHomeController({required this.villageName});

  // 임시 주민 친밀도 데이터
  final RxList<Map<String, dynamic>> memberRankings = <Map<String, dynamic>>[
    {'rank': '1위', 'name': '정수아', 'title': '✨반짝반짝 빛나는✨', 'intimacy': '98%'},
    {'rank': '2위', 'name': '손민경', 'title': '✨🌸뭔가 좋은 칭호✨', 'intimacy': '80%'},
    {'rank': '3위', 'name': '이영미', 'title': '✨지수야 사랑해~🤍✨', 'intimacy': '70%'},
    {'rank': '4위', 'name': '김밀크', 'title': '✨꼬질꼬질 따끈따끈✨', 'intimacy': '60%'},
    {'rank': '5위', 'name': '장대한', 'title': '✨빛나는 대머리✨', 'intimacy': '50%'},
  ].obs;

  // 임시 퀴즈 정답 데이터
  final RxList<Map<String, dynamic>> recentQuizzes = <Map<String, dynamic>>[
    {'question': 'Q. 김지수의 MBTI는?', 'answer': 'A. ESTP', 'date': '2025.11.25'},
    {'question': 'Q. 김지수의 생일은?', 'answer': 'A. 8월 25일', 'date': '2025.11.23'},
    {'question': 'Q. 김지수의 별자리는?', 'answer': 'A. 처녀자리', 'date': '2025.11.10'},
  ].obs;

  void goBack() {
    Get.back();
  }

  void goToQuiz() {
    Get.snackbar(
      '퀴즈 게시판',
      '퀴즈 게시판 기능 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void showMemberRankings() {
    Get.snackbar('전체 주민 친밀도 순위', '준비 중입니다.');
  }

  void showQuizAnswers() {
    Get.snackbar('역대 퀴즈 정답', '준비 중입니다.');
  }
}
