import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../post_detail_screen.dart';
import 'post_create_screen.dart';
import '../village/village_view_screen.dart';
import 'search_screen.dart';
import '../main_home_screen.dart';
import 'quiz_screen.dart';

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
  late String _selectedCategory;

  final List<String> _categories = ['전체', '일상', '게임', '취미', '퀴즈'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
  }

  /// ================= 게시글 스트림 =================
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
    final date = timestamp.toDate();
    return '${date.month}.${date.day.toString().padLeft(2, '0')}';
  }

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
                        child: Stack(
                          children: [
                            Text(
                              '마이마을',
                              style: GoogleFonts.bagelFatOne(
                                fontSize: 24,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3
                                  ..color = Colors.black,
                              ),
                            ),
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

          /// ================= 카테고리 탭 =================
          Container(
            height: 52,
            color: const Color(0xFFC4ECF6),
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      /// ⭐ 퀴즈는 게시판이 아니라 퀴즈 화면으로 이동
                      if (category == '퀴즈') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              villageName: widget.villageName,
                              villageId: widget.villageId,
                            ),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _selectedCategory = category;
                      });
                    },
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
                );
              }).toList(),
            ),
          ),

          /// ================= 게시글 목록 =================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getPostStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                    final data =
                        docs[index].data() as Map<String, dynamic>;

                    return _PostCard(
                      postId: docs[index].id,
                      title: data['title'] ?? '',
                      time: _formatTimestamp(data['createdAt']),
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

/// ================= 게시글 카드 =================
class _PostCard extends StatelessWidget {
  final String postId;
  final String title;
  final String time;
  final String villageId;

  const _PostCard({
    required this.postId,
    required this.title,
    required this.time,
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
