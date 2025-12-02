import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'board_list_screen.dart';
import 'quiz_screen.dart';
import '../main_home_screen.dart';
import '../village/village_view_screen.dart';

class BoardScreen extends StatefulWidget {
  final String villageName;

  const BoardScreen({super.key, required this.villageName});

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
        width: 393,
        height: 852,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Stack(
          children: [
            // 그라디언트 배경
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 393,
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
              child: Container(
                width: 393,
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
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.search, size: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // 상단바 (시간, 배터리 등)
            Positioned(
              left: -4,
              top: 2,
              child: Container(
                width: 402,
                padding: const EdgeInsets.only(
                  top: 21,
                  left: 16,
                  right: 16,
                  bottom: 19,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 22,
                      padding: const EdgeInsets.only(top: 2),
                      child: const Text(
                        '9:41',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Opacity(
                          opacity: 0.35,
                          child: Container(
                            width: 25,
                            height: 13,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(4.30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Container(
                          width: 21,
                          height: 9,
                          decoration: ShapeDecoration(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 다이나믹 아일랜드
            Positioned(
              left: 129,
              top: 16,
              child: Container(
                width: 131,
                height: 33,
                decoration: ShapeDecoration(
                  color: const Color(0xFF383838),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
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
                      builder: (context) =>
                          QuizScreen(villageName: widget.villageName),
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