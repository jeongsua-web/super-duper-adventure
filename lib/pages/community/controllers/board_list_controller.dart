import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardListController extends GetxController {
  final String category;
  final String villageName;
  final String villageId;

  BoardListController({
    required this.category,
    required this.villageName,
    required this.villageId,
  });

  final RxString selectedCategory = '전체'.obs;
  final RxList<String> categories = <String>['전체', '일상', '게임', '취미', '퀴즈'].obs;
  final RxBool showDrawer = false.obs;
  final RxBool notificationEnabled = true.obs;
  final RxBool isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = category;
  }

  Stream<QuerySnapshot> get postStream {
    Query query = FirebaseFirestore.instance
        .collection('villages')
        .doc(villageId)
        .collection('posts');

    if (selectedCategory.value != '전체') {
      query = query.where('category', isEqualTo: selectedCategory.value);
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  Future<DocumentSnapshot?> getPinnedPost() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .where('isPinned', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        return result.docs.first;
      }
      return null;
    } catch (e) {
      debugPrint('공지 조회 오류: $e');
      return null;
    }
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    showDrawer.value = false;
  }

  void toggleDrawer() {
    showDrawer.value = !showDrawer.value;
  }

  void toggleNotification() {
    notificationEnabled.value = !notificationEnabled.value;
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void addCategory(String categoryName) {
    if (categoryName.isNotEmpty && !categories.contains(categoryName)) {
      categories.insert(categories.length - 1, categoryName);
    }
  }

  void removeCategory(String categoryName) {
    if (categoryName != '전체' && categoryName != '퀴즈') {
      categories.remove(categoryName);
      if (selectedCategory.value == categoryName) {
        selectedCategory.value = '전체';
      }
    }
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '방금 전';
    DateTime date = timestamp.toDate();
    return '${date.month}.${date.day.toString().padLeft(2, '0')}';
  }

  void goToMainHome() {
    Get.offAllNamed('/main-home');
  }

  void goToVillageView() {
    Get.toNamed('/village-view', arguments: {'villageName': villageName});
  }

  void goToSearch() {
    Get.toNamed(
      '/search',
      arguments: {'villageName': villageName, 'villageId': villageId},
    );
  }

  void goToPostDetail(String postId) {
    Get.toNamed(
      '/post-detail',
      arguments: {'postId': postId, 'villageId': villageId},
    );
  }

  void goToPostCreate() {
    Get.toNamed(
      '/post-create',
      arguments: {'villageName': villageName, 'villageId': villageId},
    );
  }

  void goToQuiz() {
    Get.toNamed(
      '/quiz',
      arguments: {'villageName': villageName, 'villageId': villageId},
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('카테고리 추가'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: '카테고리 이름 입력',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final categoryName = textController.text.trim();
              if (categoryName.isNotEmpty &&
                  !categories.contains(categoryName)) {
                addCategory(categoryName);
                Get.back();
              } else {
                Get.snackbar(
                  '알림',
                  categoryName.isEmpty ? '카테고리 이름을 입력해주세요' : '이미 존재하는 카테고리입니다',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}
