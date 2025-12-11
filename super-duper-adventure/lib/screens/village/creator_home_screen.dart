import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../community/quiz_screen.dart';

class CreatorHomeScreen extends StatelessWidget {
  final String villageName;

  const CreatorHomeScreen({super.key, required this.villageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // 프로필 영역
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // 별과 함께 프로필 원형 이미지
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // 파란색 카드 영역
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3E5FC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // 이름과 하트
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CDBFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '❤️지쑤킴❤️',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 구분선
                          Container(height: 2, color: Colors.white),
                          const SizedBox(height: 16),
                          // 주민 친밀도 순위
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    '주민 친밀도 순위',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildRankItem('1위', '정수아', '반짝반짝 빛나는✨', '98%'),
                                _buildRankItem(
                                  '2위',
                                  '손민경',
                                  '🌸뭔가 좋은 칭호✨',
                                  '80%',
                                ),
                                _buildRankItem(
                                  '3위',
                                  '이영미',
                                  '지수야 사랑해~🤍',
                                  '70%',
                                ),
                                _buildRankItem('4위', '김민크', '꼬질꼬질 따끔따끔', '60%'),
                                _buildRankItem('5위', '장대한', '빛나는 대야리✨', '50%'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 최근 퀴즈 정답
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    '최근 퀴즈 정답',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildQuizItem(
                                  'Q. 김지수의 MBTI는?',
                                  'A. ESTP',
                                  '2025.11.25',
                                ),
                                _buildQuizItem(
                                  'Q. 김지수의 생일은?',
                                  'A. 8월 25일',
                                  '2025.11.23',
                                ),
                                _buildQuizItem(
                                  'Q. 김지수의 별자리는?',
                                  'A. 처녀자리',
                                  '2025.11.10',
                                ),
                                _buildQuizItem(
                                  'Q. 김지수의 거주지는?',
                                  'A. 분당구 정자동',
                                  '2025.11.07',
                                ),
                                _buildQuizItem(
                                  'Q. 김지수의 영어이름은?',
                                  'A. Katherin',
                                  '2025.11.02',
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizScreen(
                                            villageName: villageName,
                                            villageId: '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '퀴즈 게시판으로 이동',
                                      style: GoogleFonts.gowunDodum(
                                        color: Colors.grey,
                                        fontSize: 12,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem(
    String rank,
    String name,
    String comment,
    String percentage,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            rank,
            style: GoogleFonts.gowunDodum(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  comment,
                  style: GoogleFonts.gowunDodum(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            percentage,
            style: GoogleFonts.gowunDodum(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizItem(String question, String answer, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  answer,
                  style: GoogleFonts.gowunDodum(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: GoogleFonts.gowunDodum(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
