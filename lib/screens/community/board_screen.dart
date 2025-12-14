import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'board_list_screen.dart';
import 'quiz_screen.dart';
import '../main_home_screen.dart';
import '../village/village_view_screen.dart';

class BoardScreen extends StatefulWidget {
  final String villageName;
  final String villageId;

  const BoardScreen({
    super.key,
    required this.villageName,
    required this.villageId,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String _selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== 상단 그라디언트 =====
            Container(
              width: double.infinity,
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFFC4ECF6),
                    Color(0xFF4CDBFF),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainHomeScreen(),
                        ),
                      );
                    },
                    // ✨ 텍스트 테두리 두께 수정 (6 -> 3)
                    child: Stack(
                      children: [
                        // 1. 테두리 (검은색 stroke)
                        Text(
                          '마이마을',
                          style: GoogleFonts.bagelFatOne(
                            fontSize: 26,
                            letterSpacing: 1,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3 // ✨ 여기를 3으로 줄였습니다.
                              ..color = Colors.black,
                          ),
                        ),
                        // 2. 알맹이 (흰색 fill)
                        Text(
                          '마이마을',
                          style: GoogleFonts.bagelFatOne(
                            fontSize: 26,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// ===== 마을명 + 검색 =====
            Container(
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFC4ECF6),
                border: Border(
                  top: BorderSide(width: 2, color: Color(0xFF4CDBFF)),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
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
                      style: GoogleFonts.gowunDodum(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),

            /// ===== 카테고리 영역 =====
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categoryItem('전체'),
                  _categoryItem('일상'),
                  _categoryItem('게임'),
                  _categoryItem('취미'),
                  _quizItem(),
                ],
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  /// ===== 일반 카테고리 =====
  Widget _categoryItem(String category) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategory = category);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BoardListScreen(
              category: category,
              villageName: widget.villageName,
              villageId: widget.villageId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          category,
          textAlign: TextAlign.left,
          style: GoogleFonts.gowunDodum(
            fontSize: 28,
            fontWeight: _selectedCategory == category
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
      ),
    );
  }

 /// ===== 퀴즈 =====
Widget _quizItem() {
  return GestureDetector(
    onTap: () {
      setState(() => _selectedCategory = '퀴즈'); // (선택 강조용)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            villageName: widget.villageName,
            villageId: widget.villageId,
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        '퀴즈',
        style: GoogleFonts.gowunDodum(
          fontSize: 28,
          fontWeight:
              _selectedCategory == '퀴즈'
                  ? FontWeight.w700
                  : FontWeight.w400,
        ),
      ),
    ),
  );
}
}