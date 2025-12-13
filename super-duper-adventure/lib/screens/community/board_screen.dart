import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'board_list_screen.dart';
import 'quiz_screen.dart';
import '../main_home_screen.dart';
import '../village/village_view_screen.dart';
import 'search_screen.dart';

class BoardScreen extends StatefulWidget {
  final String villageName; // 화면에 보여줄 마을 이름
  final String villageId; // [필수] 데이터베이스에서 사용할 마을 ID

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
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // 그라디언트 배경
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                height: 296,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 1.00),
                    end: Alignment(0.50, 0.00),
                    colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
                  ),
                ),
              ),
            ),

            // 검색창 영역
            Positioned(
              left: 0,
              top: 296,
              right: 0,
              child: Container(
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFC4ECF6),
                  border: Border(
                    top: BorderSide(width: 2, color: Color(0xFF4CDBFF)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VillageViewScreen(
                              villageName: widget.villageName,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        widget.villageName,
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(
                              villageName: widget.villageName,
                              villageId: widget.villageId,
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 마이마을 텍스트
            Positioned(
              left: 16,
              top: 59,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainHomeScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      '마이',
                      style: GoogleFonts.bagelFatOne(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '마을',
                      style: GoogleFonts.bagelFatOne(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 카테고리 버튼들
            Positioned(
              left: 43,
              top: 383,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardListScreen(
                        category: '전체',
                        villageName: widget.villageName,
                        villageId: widget.villageId,
                      ),
                    ),
                  );
                },
                child: Text(
                  '전체',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '전체'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 456,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardListScreen(
                        category: '일상',
                        villageName: widget.villageName,
                        villageId: widget.villageId,
                      ),
                    ),
                  );
                },
                child: Text(
                  '일상',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '일상'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 529,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardListScreen(
                        category: '게임',
                        villageName: widget.villageName,
                        villageId: widget.villageId,
                      ),
                    ),
                  );
                },
                child: Text(
                  '게임',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '게임'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 602,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardListScreen(
                        category: '취미',
                        villageName: widget.villageName,
                        villageId: widget.villageId,
                      ),
                    ),
                  );
                },
                child: Text(
                  '취미',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '취미'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 42,
              top: 675,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        villageName: widget.villageName,
                        villageId: widget.villageId,
                      ),
                    ),
                  );
                },
                child: Text(
                  '퀴즈',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '퀴즈'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
