import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class QuizSolScreen extends StatefulWidget {
  final String villageName;

  const QuizSolScreen({super.key, required this.villageName});

  @override
  State<QuizSolScreen> createState() => _QuizSolScreenState();
}

class _QuizSolScreenState extends State<QuizSolScreen> {
  final TextEditingController _answerController = TextEditingController();

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
                          widget.villageName,
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

                  // 입력 필드
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _answerController,
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: '정답을 입력하세요.',
                        hintStyle: GoogleFonts.gowunDodum(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 시간 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '남은 시간',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '12시간 13분',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 정답 제출 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // 정답 제출 로직
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4ECF6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '정답제출',
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
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
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
