import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_create_screen.dart';
import '../post_detail_screen.dart';

class BoardScreen extends StatefulWidget {
  final String villageName; // 화면에 보여줄 마을 이름 (예: "행복마을")
  final String villageId;   // [필수] 데이터베이스에서 사용할 마을 ID (예: "6qUP...")

  const BoardScreen({
    super.key,
    required this.villageName,
    required this.villageId, // 이 부분이 추가되었습니다.
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '일상', '게임', '취미', '퀴즈'];

  Stream<QuerySnapshot> _getPostStream() {
    // [수정 1] 게시글을 불러올 때 'posts'가 아니라 'villages/{villageId}/posts'에서 가져옴
    Query query = FirebaseFirestore.instance
        .collection('villages')
        .doc(widget.villageId) // 받아온 villageId 사용
        .collection('posts');

    if (_selectedCategory != '전체') {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    return query.orderBy('createdAt', descending: true).snapshots();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '방금 전';
    DateTime date = timestamp.toDate();
    return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ---------------- [1. 헤더] ----------------
                Container(
                  width: double.infinity,
                  height: 200,
                  color: const Color(0xFFD9D9D9),
                  child: Stack(
                    children: [
                      const Positioned(
                        left: 16,
                        top: 16,
                        child: Text(
                          'MyMaeul',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          '마을 전경',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 36,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- [2. 카테고리] ----------------
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        for (final category in _categories)
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (_selectedCategory == category)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      height: 2,
                                      width: 45,
                                      color: Colors.black,
                                    )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ---------------- [3. 검색창] ----------------
                Container(
                  height: 55,
                  color: const Color(0xFFD9D9D9).withOpacity(0.41),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.villageName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9D9D9),
                        ),
                        child: const Center(
                          child: Icon(Icons.search, size: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- [4. 게시글 목록] ----------------
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getPostStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('에러: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text("'$_selectedCategory' 게시글이 없습니다."));
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          String category = data['category'] ?? '기타';
                          int commentCount = data['commentCount'] ?? 0;

                          return _PostCard(
                            postId: docs[index].id,
                            // [수정 2] PostCard에도 villageId를 전달해야 상세화면으로 넘어갈 수 있음
                            villageId: widget.villageId, 
                            title: data['title'] ?? '제목 없음',
                            author: '[$category] ${data['author'] ?? '익명'}',
                            time: _formatTimestamp(data['createdAt']),
                            comments: commentCount.toString(),
                            hasImage: false,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ---------------- [5. 글쓰기 버튼 (여기서 연결)] ----------------
      floatingActionButton: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            // [수정 3] 여기서 질문하신 코드가 들어갑니다!
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostCreateScreen(
                    // BoardScreen이 가지고 있는 villageId를 그대로 전달
                    villageId: widget.villageId, 
                  ),
                ),
              );
            },
            backgroundColor: const Color(0xFFFFA9A9),
            shape: const CircleBorder(
              side: BorderSide(color: Colors.black, width: 1),
            ),
            child: const Text(
              '글쓰기',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// --- _PostCard 위젯 ---
class _PostCard extends StatelessWidget {
  final String postId;
  final String villageId; // [수정 4] villageId 필드 추가
  final String title;
  final String author;
  final String time;
  final String comments;
  final bool hasImage;

  const _PostCard({
    required this.postId,
    required this.villageId, // [수정 4] 생성자에서 받기
    required this.title,
    required this.author,
    required this.time,
    required this.comments,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // [수정 5] 상세화면으로 이동할 때도 villageId 전달
            builder: (context) => PostDetailScreen(
              postId: postId, 
              villageId: villageId
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 27,
              top: 16,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              left: 30,
              bottom: 16,
              child: Text(
                '$author | $time | 댓글 $comments',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (hasImage)
              Positioned(
                right: 27,
                top: 20,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 30, color: Colors.black54),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}