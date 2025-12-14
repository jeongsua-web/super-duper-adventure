import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final List<String> categories = ['전체', '일상', '게임', '취미', '퀴즈'];

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

  void updateCategory(String category) {
    selectedCategory.value = category;
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
    Get.toNamed('/search', arguments: {'villageName': villageName});
  }

  void goToPostDetail(String postId) {
    Get.toNamed('/post-detail', arguments: {
      'postId': postId,
      'villageId': villageId,
    });
  }

  void goToPostCreate() {
    Get.toNamed('/post-create', arguments: {
      'villageName': villageName,
      'villageId': villageId,
    });
  }
}
