import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/board_list_controller.dart';

class BoardListView extends GetView<BoardListController> {
  const BoardListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 그라디언트 헤더
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, 1.00),
                end: Alignment(0.50, 0.00),
                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 상단바 (시간, 배터리)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '9:41',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.signal_cellular_4_bar, size: 16),
                            const SizedBox(width: 4),
                            const Icon(Icons.wifi, size: 16),
                            const SizedBox(width: 4),
                            Container(
                              width: 24,
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 8,
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 마이마을 로고와 마을 이름
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Stack(
                      children: [
                        // 왼쪽: 마이마을 로고
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: controller.goToMainHome,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '마이',
                                  style: GoogleFonts.bagelFatOne(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  '마을',
                                  style: GoogleFonts.bagelFatOne(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 중앙: 마을 이름
                        Center(
                          child: GestureDetector(
                            onTap: controller.goToVillageView,
                            child: Text(
                              controller.villageName,
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        // 오른쪽: 검색 아이콘
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: controller.goToSearch,
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 카테고리 탭
          Obx(() => Container(
            width: double.infinity,
            height: 45,
            decoration: const BoxDecoration(color: Color(0xFFC4ECF6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...controller.categories.map((category) {
                  final isSelected = category == controller.selectedCategory.value;
                  return GestureDetector(
                    onTap: () => controller.updateCategory(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category,
                            style: GoogleFonts.gowunDodum(
                              color: isSelected
                                  ? Colors.black
                                  : const Color(0xFF6D6D6D),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isSelected)
                            Container(
                              width: 36,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF07C7F7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                // 메뉴 아이콘
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.menu, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          )),

          // 공지 영역
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB9B9B9).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CDBFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '공지',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '공지제목',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 게시글 목록
          Expanded(
            child: Obx(() => StreamBuilder<QuerySnapshot>(
              stream: controller.postStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('에러: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "'${controller.selectedCategory.value}' 게시글이 없습니다.",
                      style: GoogleFonts.gowunDodum(fontSize: 16),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    String author = data['author'] ?? '익명';
                    int commentCount = data['commentCount'] ?? 0;

                    return _PostCard(
                      postId: docs[index].id,
                      title: data['title'] ?? '제목 없음',
                      author: author,
                      time: controller.formatTimestamp(data['createdAt']),
                      comments: commentCount.toString(),
                      hasImage: data['imageUrl'] != null,
                      imageUrl: data['imageUrl'] as String?,
                      onTap: () => controller.goToPostDetail(docs[index].id),
                    );
                  },
                );
              },
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToPostCreate,
        backgroundColor: const Color(0xFF4CDBFF),
        shape: const CircleBorder(
          side: BorderSide(color: Color(0xFF0094FF), width: 3),
        ),
        child: const Icon(Icons.edit, color: Colors.white, size: 24),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String postId;
  final String title;
  final String author;
  final String time;
  final String comments;
  final bool hasImage;
  final String? imageUrl;
  final VoidCallback onTap;

  const _PostCard({
    required this.postId,
    required this.title,
    required this.author,
    required this.time,
    required this.comments,
    this.hasImage = false,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.gowunDodum(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$author | $time | $comments',
                    style: GoogleFonts.gowunDodum(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (hasImage && imageUrl != null) ...[
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFC4ECF6), width: 3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE0E0E0),
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
