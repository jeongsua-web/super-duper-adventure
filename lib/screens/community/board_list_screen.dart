import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../post_detail_screen.dart';
import 'post_create_screen.dart';
import '../village/village_view_screen.dart';
import 'search_screen.dart';
import '../main_home_screen.dart';

class BoardListScreen extends StatefulWidget {
  final String category;
  final String villageName;
  final String villageId;

  const BoardListScreen({
    super.key,
    required this.category,
    required this.villageName,
    required this.villageId,
  });

  @override
  State<BoardListScreen> createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen> {
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '일상', '게임', '취미', '퀴즈'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  Stream<QuerySnapshot> _getPostStream() {
    Query query = FirebaseFirestore.instance
        .collection('villages')
        .doc(widget.villageId)
        .collection('posts');

    if (_selectedCategory != '전체') {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '방금 전';
    DateTime date = timestamp.toDate();
    return '${date.month}.${date.day.toString().padLeft(2, '0')}';
  }

  // ✨ _getTextOutline 함수 제거됨 (Stack 방식으로 대체)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// ================= 상단 헤더 =================
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainHomeScreen(),
                            ),
                          );
                        },
                        // ✨ 텍스트 테두리 효과 수정 (Stack + Paint, 두께 3)
                        child: Stack(
                          children: [
                            // 1. 테두리 (검은색 stroke)
                            Text(
                              '마이마을',
                              style: GoogleFonts.bagelFatOne(
                                fontSize: 24,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3 // 두께 3 적용
                                  ..color = Colors.black,
                              ),
                            ),
                            // 2. 알맹이 (흰색 fill)
                            Text(
                              '마이마을',
                              style: GoogleFonts.bagelFatOne(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VillageViewScreen(
                                villageName: widget.villageName,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          widget.villageName,
                          style: GoogleFonts.gowunDodum(fontSize: 20),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SearchScreen(
                                villageName: widget.villageName,
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ================= 카테고리 탭 (터치 영역 확장) =================
          Container(
            height: 52,
            color: const Color(0xFFC4ECF6),
            child: Row(
              children: [
                ..._categories.map((category) {
                  final isSelected = category == _selectedCategory;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category,
                              style: GoogleFonts.gowunDodum(
                                fontSize: 20,
                                color: isSelected
                                    ? Colors.black
                                    : const Color(0xFF6D6D6D),
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
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          /// ================= 게시글 목록 =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getPostStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "'$_selectedCategory' 게시글이 없습니다.",
                      style: GoogleFonts.gowunDodum(fontSize: 16),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return _PostCard(
                      postId: docs[index].id,
                      title: data['title'] ?? '',
                      author: data['author'] ?? '익명',
                      time: _formatTimestamp(data['createdAt']),
                      comments: (data['commentCount'] ?? 0).toString(),
                      hasImage: data['imageUrl'] != null,
                      imageUrl: data['imageUrl'],
                      villageId: widget.villageId,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      /// ================= 글쓰기 버튼 =================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostCreateScreen(
                villageName: widget.villageName,
                villageId: widget.villageId,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF4CDBFF),
        child: const Icon(Icons.edit, color: Colors.white),
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
  final String villageId;

  const _PostCard({
    required this.postId,
    required this.title,
    required this.author,
    required this.time,
    required this.comments,
    required this.hasImage,
    this.imageUrl,
    required this.villageId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PostDetailScreen(postId: postId, villageId: villageId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.gowunDodum(fontSize: 20),
        ),
      ),
    );
  }
}