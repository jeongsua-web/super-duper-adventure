import 'package:flutter/material.dart';
import 'post_create_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: 393,
              height: 293,
              color: const Color(0xFFD9D9D9),
              child: Stack(
                children: [
                  // MyMaeul text
                  Positioned(
                    left: 7,
                    top: 18,
                    child: Text(
                      'MyMaeul',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.1875,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // 마을 전경 title
                  Positioned(
                    left: 125,
                    top: 124,
                    child: Text(
                      '마을 전경',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 36,
                        height: 1.222,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category selector
            SizedBox(
              width: 393,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in _categories)
                      Padding(
                        padding: EdgeInsets.only(
                          left: category == '전체' ? 46 : 0,
                          right: 30,
                        ),
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
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  color: Colors.black,
                                  letterSpacing: 0.01,
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

            const SizedBox(height: 20),

            // Search bar
            Container(
              height: 55,
              color: const Color(0xFFD9D9D9).withValues(alpha: 0.41),
              child: Stack(
                children: [
                  // Village name
                  Positioned(
                    left: 158,
                    top: 306,
                    child: Text(
                      widget.villageName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        height: 1.208,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Search button
                  Positioned(
                    left: 341,
                    top: 301,
                    child: GestureDetector(
                      onTap: () {
                        // Handle search
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9D9D9),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Posts list
            Expanded(
              child: ListView(
                children: [
                  _PostCard(
                    title: '글제목',
                    author: '작성자',
                    time: '시간',
                    comments: '댓글수',
                    hasImage: true,
                  ),
                  _PostCard(
                    title: '글제목',
                    author: '작성자',
                    time: '시간',
                    comments: '댓글수',
                    hasImage: false,
                  ),
                  _PostCard(
                    title: '글제목',
                    author: '작성자',
                    time: '시간',
                    comments: '댓글수',
                    hasImage: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating Write Button
      floatingActionButton: FloatingActionButton(
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
    );
  }
}

class _PostCard extends StatelessWidget {
  final String title;
  final String author;
  final String time;
  final String comments;
  final bool hasImage;

  const _PostCard({
    required this.title,
    required this.author,
    required this.time,
    required this.comments,
    this.hasImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Stack(
        children: [
          // Post title
          Positioned(
            left: 27,
            top: 16,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),

          // Author | Time | Comments
          Positioned(
            left: 30,
            bottom: 16,
            child: Text(
              '$author | $time | $comments',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.1875,
                color: Colors.black,
              ),
            ),
          ),

          // Image
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
                  child: Icon(
                    Icons.image,
                    size: 30,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
