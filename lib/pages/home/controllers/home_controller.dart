import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final RxString searchQuery = ''.obs;

  // 프로필 화면 이동
  void navigateToProfile() {
    // TODO: 프로필 화면 라우트 추가 필요
    Get.snackbar(
      '준비 중',
      '프로필 화면은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 게시판 이동
  void navigateToBoard() {
    Get.toNamed(
      AppRoutes.board,
      arguments: {
        'villageName': '우리 마을',
        'villageId': '',
      },
    );
  }

  // 퀴즈 이동
  void navigateToQuiz() {
    Get.toNamed(
      AppRoutes.quiz,
      arguments: {
        'villageName': '우리 마을',
        'villageId': '',
      },
    );
  }

  // 일정 이동
  void navigateToCalendar() {
    Get.snackbar(
      '준비 중',
      '일정 화면은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 검색어 업데이트
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // 검색 실행
  void performSearch() {
    if (searchQuery.value.isEmpty) {
      Get.snackbar(
        '검색',
        '검색어를 입력하세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      '검색',
      '검색어: ${searchQuery.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 필터
  void openFilter() {
    Get.snackbar(
      '필터',
      '필터 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // FAB 액션
  void onAddPressed() {
    Get.snackbar(
      '추가',
      '추가 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
