import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../village/village_view_screen.dart';
import '../main_home_screen.dart';
import 'quiz_sol_screen.dart';
import 'quiz_view_screen.dart';
import 'quiz_create_screen.dart';

class QuizScreen extends StatelessWidget {
  final String villageName;
  final String villageId;

  const QuizScreen({
    super.key,
    required this.villageName,
    required this.villageId,
  });

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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainHomeScreen(),
                                ),
                              );
                            },
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VillageViewScreen(
                                    villageName: villageName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              villageName,
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        // 오른쾽: 글쓰기 아이콘
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizCreateScreen(
                                      villageName: villageName,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 28,
                              ),
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

          // 퀴즈 컨텐츠 영역
          Expanded(
            child: Container(
              width: 393,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 24,
                    top: 20,
                    child: Text(
                      '진행중인 퀴즈',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    top: 365,
                    child: Text(
                      '종료된 퀴즈',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 29,
                    top: 85,
                    child: Container(
                      width: 334,
                      height: 240,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 49,
                    top: 242,
                    child: Container(
                      width: 294,
                      height: 66,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 29,
                    top: 540,
                    child: Container(
                      width: 334,
                      height: 66,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 29,
                    top: 450,
                    child: Container(
                      width: 334,
                      height: 66,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 29,
                    top: 630,
                    child: Container(
                      width: 334,
                      height: 66,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 29,
                    top: 720,
                    child: Container(
                      width: 334,
                      height: 66,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 43,
                    top: 104,
                    child: Text(
                      '고양이 이름이 뭘까',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 148,
                    top: 258,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizSolScreen(villageName: villageName),
                          ),
                        );
                      },
                      child: Text(
                        '퀴즈 풀기',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 465,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizViewScreen(villageName: villageName),
                          ),
                        );
                      },
                      child: Text(
                        '퀴즈 제목',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 555,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizViewScreen(villageName: villageName),
                          ),
                        );
                      },
                      child: Text(
                        '퀴즈 제목',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 645,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizViewScreen(villageName: villageName),
                          ),
                        );
                      },
                      child: Text(
                        '퀴즈 제목',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 735,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizViewScreen(villageName: villageName),
                          ),
                        );
                      },
                      child: Text(
                        '퀴즈 제목',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 43,
                    top: 163,
                    child: Text(
                      '사진 속 아련하게 쳐다보는\n고양이의 이름을 맞쳐보렴',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 265,
                    top: 473,
                    child: Text(
                      '2034.2.12',
                      style: GoogleFonts.gowunDodum(
                        color: const Color(0xFF595959),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 265,
                    top: 563,
                    child: Text(
                      '2034.2.12',
                      style: GoogleFonts.gowunDodum(
                        color: const Color(0xFF595959),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 265,
                    top: 653,
                    child: Text(
                      '2034.2.12',
                      style: GoogleFonts.gowunDodum(
                        color: const Color(0xFF595959),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 265,
                    top: 743,
                    child: Text(
                      '2034.2.12',
                      style: GoogleFonts.gowunDodum(
                        color: const Color(0xFF595959),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
