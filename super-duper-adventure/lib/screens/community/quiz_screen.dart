import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../village/village_view_screen.dart';

class QuizScreen extends StatelessWidget {
  final String villageName;

  const QuizScreen({super.key, required this.villageName});

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
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 393,
                height: 94,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 1.00),
                    end: Alignment(0.50, 0.00),
                    colors: [const Color(0xFFC4ECF6), const Color(0xFF4CDBFF)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 158,
              top: 62,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VillageViewScreen(villageName: villageName),
                    ),
                  );
                },
                child: Text(
                  villageName,
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    height: 0.90,
                  ),
                ),
              ),
            ),
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 154,
                  children: [
                    Expanded(
                      child: Container(
                        height: 22,
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Text(
                              '9:41',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black /* Labels-Primary */,
                                fontSize: 17,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                                height: 1.29,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 22,
                        padding: const EdgeInsets.only(top: 1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 7,
                          children: [
                            Opacity(
                              opacity: 0.35,
                              child: Container(
                                width: 25,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.black /* Labels-Primary */,
                                    ),
                                    borderRadius: BorderRadius.circular(4.30),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 21,
                              height: 9,
                              decoration: ShapeDecoration(
                                color: Colors.black /* Labels-Primary */,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            Positioned(
              left: 358,
              top: 59,
              child: Container(
                width: 24,
                height: 24,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
              ),
            ),
            Positioned(
              left: 12,
              top: 59,
              child: Container(
                width: 24,
                height: 24,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Stack(),
              ),
            ),
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
    );
  }
}
