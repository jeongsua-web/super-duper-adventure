import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class QuizViewScreen extends StatelessWidget {
  final String villageName;

  const QuizViewScreen({super.key, required this.villageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 헤더
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          villageName,
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 28),
                    ],
                  ),
                ),
              ),
            ),

            // 퀴즈 콘텐츠 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 퀴즈 제목
                  Text(
                    '고양이 이름이 뭘까',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 고양이 사진
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 280,
                        height: 280,
                        color: Colors.grey[300],
                        child: Image.asset(
                          'assets/images/cat.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                '사진을 로드할 수 없습니다',
                                style: GoogleFonts.gowunDodum(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 퀴즈 설명
                  Center(
                    child: Text(
                      '사진 속 아련하게 쳐다보는\n고양이의 이름을 맞쳐보렴',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 구분선
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 20),

                  // 정답
                  Text(
                    '정답',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '우돌',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
