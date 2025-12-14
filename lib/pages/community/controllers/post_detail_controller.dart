import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailController extends GetxController {
  final String postId;
  final String villageId;

  PostDetailController({
    required this.postId,
    required this.villageId,
  });

  final TextEditingController commentController = TextEditingController();
  final Rx<DocumentSnapshot?> postData = Rx<DocumentSnapshot?>(null);
  final RxList<DocumentSnapshot> comments = <DocumentSnapshot>[].obs;
  final RxBool isLoadingPost = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPost();
    listenToComments();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  // 게시글 데이터 로드
  Future<void> loadPost() async {
    try {
      isLoadingPost.value = true;
      final doc = await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .doc(postId)
          .get();
      
      postData.value = doc;
      isLoadingPost.value = false;
    } catch (e) {
      isLoadingPost.value = false;
      Get.snackbar(
        '오류',
        '게시글을 불러올 수 없습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 댓글 실시간 리스닝
  void listenToComments() {
    FirebaseFirestore.instance
        .collection('villages')
        .doc(villageId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      comments.value = snapshot.docs;
    });
  }

  // 댓글 추가
  Future<void> addComment() async {
    if (commentController.text.isEmpty) return;

    try {
      final postRef = FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .doc(postId);

      // 댓글 저장
      await postRef.collection('comments').add({
        'content': commentController.text,
        'author': '익명',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 댓글 수 증가
      await postRef.update({
        'comments': FieldValue.increment(1),
      });

      commentController.clear();
      Get.focusScope?.unfocus();
    } catch (e) {
      Get.snackbar(
        '오류',
        '댓글 작성 실패: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 날짜 포맷
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '방금 전';
    DateTime date = timestamp.toDate();
    return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // 뒤로가기
  void goBack() {
    Get.back();
  }
}
