import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('게시글 상세'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // --- 게시글 내용 & 댓글 목록 (스크롤 영역) ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // [1] 게시글 데이터
                      Obx(() {
                        if (controller.isLoadingPost.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final snapshot = controller.postData.value;
                        if (snapshot == null || !snapshot.exists) {
                          return const Text("삭제된 글입니다.");
                        }

                        final data = snapshot.data() as Map<String, dynamic>?;
                        if (data == null) return const Text("삭제된 글입니다.");

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? '제목 없음',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFFD9D9D9),
                                  child: Icon(Icons.person, color: Colors.grey),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['author'] ?? '익명',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      controller.formatTimestamp(data['createdAt']),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 40, thickness: 1),
                            Text(
                              data['content'] ?? '',
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ],
                        );
                      }),

                      const Divider(height: 40, thickness: 1),

                      // [2] 댓글 목록
                      const Text(
                        '댓글',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      Obx(() {
                        final commentsList = controller.comments;

                        if (commentsList.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("첫 번째 댓글을 남겨보세요!"),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: commentsList.length,
                          itemBuilder: (context, index) {
                            final commentData =
                                commentsList[index].data() as Map<String, dynamic>;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        commentData['author'] ?? '익명',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        controller.formatTimestamp(commentData['createdAt']),
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(commentData['content'] ?? ''),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // --- [3] 댓글 입력창 (하단 고정) ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: controller.commentController,
                          decoration: const InputDecoration(
                            hintText: '댓글을 입력하세요...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => controller.addComment(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: controller.addComment,
                      icon: const Icon(Icons.send, color: Color(0xFFFFA9A9)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
