import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CommunitySearchController extends GetxController {
  final String villageName;

  CommunitySearchController({required this.villageName});

  final TextEditingController searchController = TextEditingController();
  final RxList<String> recentSearches = <String>[
    '고양이',
    '우돌',
    '두발',
    '초록',
    '지수',
  ].obs;

  final RxString searchQuery = ''.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // 검색 실행
  void performSearch() {
    if (searchController.text.isEmpty) {
      Get.snackbar(
        '알림',
        '검색어를 입력하세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 최근 검색어에 추가 (중복 제거)
    recentSearches.remove(searchController.text);
    recentSearches.insert(0, searchController.text);

    // 최대 10개까지만 유지
    if (recentSearches.length > 10) {
      recentSearches.removeLast();
    }

    Get.snackbar(
      '검색',
      '검색어: ${searchController.text}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 검색어 삭제
  void deleteSearch(String keyword) {
    recentSearches.remove(keyword);
  }

  // 전체 삭제
  void clearAllSearches() {
    recentSearches.clear();
    Get.snackbar(
      '알림',
      '검색 기록이 삭제되었습니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // 뒤로가기
  void goBack() {
    Get.back();
  }
}
