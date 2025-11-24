import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_create_screen.dart';
import '../post_detail_screen.dart';

class BoardScreen extends StatefulWidget {
  final String villageName;

  const BoardScreen({
    super.key,
    required this.villageName,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '일상', '게임', '취미', '퀴즈'];

  Stream<QuerySnapshot> _getPostStream() {
    Query query = FirebaseFirestore.instance.collection('posts');

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
    // [핵심] 화면 전체를 Center로 감싸서 어떤 화면 크기든 중앙 정렬
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 (PC에서는 양옆 여백 색이 됨)
      body: Center(
        child: Container(
          width: double.infinity, // 기본적으로 꽉 차게 하되
          constraints: const BoxConstraints(maxWidth: 600), // 최대 600px까지만 늘어남 (반응형 핵심)
          decoration: BoxDecoration(
            color: Colors.white, // 콘텐츠 영역 배경
            // (선택사항) PC에서 구분이 잘 가게 옅은 그림자 추가
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
                // ---------------- [1. 헤더 (반응형)] ----------------
                Container(
                  width: double.infinity,
                  height: 200,
                  color: const Color(0xFFD9D9D9),
                  child: Stack(
                    children: [
                      // 왼쪽 상단 로고 (항상 왼쪽 고정)
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
                      // 중앙 타이틀 (항상 정가운데 고정)
                      const Center(
                        child: Text(
                          '마을 전경',
                          textAlign: TextAlign.center, // 글자 자체도 가운데 정렬
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

                // ---------------- [2. 카테고리 (반응형)] ----------------
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      // Row는 기본적으로 왼쪽 정렬이지만, 스크롤뷰라서 자연스러움
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

                // ---------------- [3. 검색창 (반응형)] ----------------
                Container(
                  height: 55,
                  color: const Color(0xFFD9D9D9).withOpacity(0.41),
                  // Row + MainAxisAlignment.center 조합으로 무조건 가운데 정렬
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
                      const SizedBox(width: 20), // 간격 유지
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

                // ---------------- [4. 게시글 목록 (반응형)] ----------------
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

                          // [수정됨] Firestore에서 'commentCount' 필드를 가져옵니다.
                          // 만약 필드가 없다면 0으로 처리합니다.
                          int commentCount = data['commentCount'] ?? 0;

                          return _PostCard(
                            postId: docs[index].id,
                            title: data['title'] ?? '제목 없음',
                            author: '[$category] ${data['author'] ?? '익명'}',
                            time: _formatTimestamp(data['createdAt']),
                            // [수정됨] 숫자를 문자열로 변환하여 전달
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

      // ---------------- [5. 글쓰기 버튼 (반응형)] ----------------
      // 버튼 위치도 화면 중앙 컨테이너 기준으로 잡기 위해 별도 처리
      floatingActionButton: Center(
        child: Container(
           // 화면 전체 너비 제한과 동일하게 맞춤
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          // Align을 써서 컨테이너 안에서 오른쪽 아래로 보냄
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PostCreateScreen(),
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
      // 플로팅 버튼 위치를 커스텀하게 잡았으므로 기본 위치는 비활성화
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// --- _PostCard 위젯 (수정 없음) ---
class _PostCard extends StatelessWidget {
  final String postId;
  final String title;
  final String author;
  final String time;
  final String comments;
  final bool hasImage;

  const _PostCard({
    required this.postId,
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
            builder: (context) => PostDetailScreen(postId: postId),
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