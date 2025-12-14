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
  final RxMap<String, bool> likedPosts = <String, bool>{}.obs;

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

  // 좋아요 토글
  Future<void> toggleLike() async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .doc(postId);

      final isLiked = likedPosts[postId] ?? false;
      likedPosts[postId] = !isLiked;

      if (isLiked) {
        await postRef.update({'likes': FieldValue.increment(-1)});
      } else {
        await postRef.update({'likes': FieldValue.increment(1)});
      }
    } catch (e) {
      Get.snackbar('오류', '좋아요 처리 실패: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 게시글 메뉴 표시
  void showPostMenu() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('villages')
              .doc(villageId)
              .collection('posts')
              .doc(postId)
              .get(),
          builder: (context, snapshot) {
            final isPinned =
                (snapshot.data?.data() as Map<String, dynamic>?)?['isPinned'] ?? false;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '게시글 관리',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit, color: Color(0xFF4DDBFF)),
                  title: const Text('수정'),
                  onTap: () {
                    Get.back();
                    editPost();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('삭제', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Get.back();
                    deletePost();
                  },
                ),
                if (!isPinned)
                  ListTile(
                    leading: const Icon(Icons.push_pin, color: Color(0xFFFFB800)),
                    title: const Text('공지로 등록'),
                    onTap: () {
                      Get.back();
                      pinPost();
                    },
                  ),
                if (isPinned)
                  ListTile(
                    leading: const Icon(Icons.close, color: Color(0xFFFFB800)),
                    title: const Text('공지 등록취소'),
                    onTap: () {
                      Get.back();
                      unpinPost();
                    },
                  ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  // 게시글 수정
  void editPost() {
    Get.snackbar('수정', '수정 기능은 준비 중입니다.', snackPosition: SnackPosition.BOTTOM);
  }

  // 게시글 삭제
  void deletePost() {
    Get.defaultDialog(
      title: '게시글 삭제',
      middleText: '정말로 삭제하시겠습니까?',
      textCancel: '취소',
      textConfirm: '삭제',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await performDelete();
      },
    );
  }

  // 삭제 실행
  Future<void> performDelete() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .doc(postId)
          .delete();

      Get.back();
      Get.snackbar('삭제 완료', '게시글이 삭제되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('오류', '삭제 중 오류가 발생했습니다: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 공지로 등록
  Future<void> pinPost() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .doc(postId)
          .update({'isPinned': true});

      Get.snackbar('완료', '공지로 등록되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('오류', '공지 등록 중 오류가 발생했습니다: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 공지 등록 취소
  Future<void> unpinPost() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .doc(postId)
          .update({'isPinned': false});

      Get.snackbar('완료', '공지 등록이 취소되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('오류', '공지 등록취소 중 오류가 발생했습니다: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
