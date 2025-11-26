import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../village/village_view_screen.dart';
import '../main_home_screen.dart';

class QuizScreen extends StatelessWidget {
  final String villageName;

  const QuizScreen({super.key, required this.villageName});

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
                        // 오른쪽: 검색 아이콘
                        Align(
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 28,
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
                    top: 114,
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
                    top: 479,
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
                    top: 179,
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
                    top: 336,
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
                    top: 634,
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
                    top: 544,
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
                    top: 724,
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
                    top: 814,
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
                    top: 198,
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
                    top: 352,
                    child: Text(
                      '퀴즈 풀기',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 559,
                    child: Text(
                      '퀴즈 제목',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 45,
                    top: 649,
                    child: Text(
                      '퀴즈 제목',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 739,
                    child: Text(
                      '퀴즈 제목',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 829,
                    child: Text(
                      '퀴즈 제목',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 43,
                    top: 257,
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
                    top: 567,
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
                    top: 657,
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
                    top: 747,
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
                    top: 837,
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
