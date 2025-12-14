import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 헤더 (그라디언트 배경)
          Obx(() {
            final snapshot = controller.postData.value;
            final title = (snapshot?.data() as Map<String, dynamic>?)?['title'] ?? '게시글';

            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 15,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF4DDBFF), Color(0xFFC4ECF6)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: GoogleFonts.gowunDodum(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.showPostMenu,
                    child: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                  ),
                ],
              ),
            );
          }),

          // 게시글 내용 및 댓글
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자 정보
                  Obx(() {
                    if (controller.isLoadingPost.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final snapshot = controller.postData.value;
                    if (snapshot == null || !snapshot.exists) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("삭제된 글입니다."),
                      );
                    }

                    final data = snapshot.data() as Map<String, dynamic>?;
                    if (data == null) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("삭제된 글입니다."),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 작성자 정보 섹션
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFFD9D9D9),
                                child: Icon(Icons.person, color: Colors.grey, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['author'] ?? '익명',
                                      style: GoogleFonts.gowunDodum(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      controller.formatTimestamp(data['createdAt']),
                                      style: GoogleFonts.gowunDodum(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 게시글 이미지 (있는 경우)
                        if (data['imageUrl'] != null && (data['imageUrl'] as String).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['imageUrl'],
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 250,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 64),
                                  );
                                },
                              ),
                            ),
                          ),

                        // 게시글 내용
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            data['content'] ?? '',
                            style: GoogleFonts.gowunDodum(fontSize: 16, height: 1.6),
                          ),
                        ),

                        const Divider(height: 32, thickness: 1),

                        // 좋아요 버튼
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                final isLiked = controller.likedPosts[controller.postId] ?? false;
                                return GestureDetector(
                                  onTap: controller.toggleLike,
                                  child: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                    size: 32,
                                  ),
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '${data['likes'] ?? 0}',
                                style: GoogleFonts.gowunDodum(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 32, thickness: 1),

                        // 댓글 목록
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '댓글',
                                style: GoogleFonts.gowunDodum(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
                                      padding: const EdgeInsets.all(12),
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
                                                style: GoogleFonts.gowunDodum(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                controller.formatTimestamp(commentData['createdAt']),
                                                style: GoogleFonts.gowunDodum(
                                                  color: Colors.grey,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            commentData['content'] ?? '',
                                            style: GoogleFonts.gowunDodum(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // 댓글 입력창
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: SafeArea(
              top: false,
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
                        decoration: InputDecoration(
                          hintText: '댓글을 입력하세요...',
                          hintStyle: GoogleFonts.gowunDodum(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.gowunDodum(),
                        onSubmitted: (_) => controller.addComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: controller.addComment,
                    icon: const Icon(Icons.send, color: Color(0xFF4DDBFF)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
