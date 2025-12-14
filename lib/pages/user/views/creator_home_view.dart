import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/creator_home_controller.dart';

class CreatorHomeView extends GetView<CreatorHomeController> {
  const CreatorHomeView({super.key});

  Widget _buildRankItem(
    String rank,
    String name,
    String title,
    String intimacy,
  ) {
    // 1위, 3위, 5위인지 확인
    bool isHighlight = rank == '1위' || rank == '3위' || rank == '5위';

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFFC4ECF6) : Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
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
                    title,
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
              intimacy,
              style: GoogleFonts.gowunDodum(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizItem(
    String question,
    String answer,
    String date,
    int index,
  ) {
    // 1번, 3번, 5번 항목인지 확인 (index는 0부터 시작하므로 0, 2, 4)
    bool isHighlight = index == 0 || index == 2 || index == 4;

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFFC4ECF6) : Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
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
                      fontSize: 11,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC4ECF6), Color(0xFF4DDBFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 상단 바
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: controller.goBack,
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
                const SizedBox(height: 20),
                // 프로필 원형 이미지
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(Icons.person, size: 80, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // 이름과 하트
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF4DDBFF),
                      width: 2,
                    ),
                  ),
                  child: Obx(
                    () => Text(
                      controller.currentUserName.value,
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 주민 친밀도 순위
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (controller.memberRankings.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                '아직 주민이 없습니다',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: controller.memberRankings
                              .asMap()
                              .entries
                              .map((entry) {
                                final member = entry.value;
                                return _buildRankItem(
                                  member['rank'],
                                  member['name'],
                                  member['title'],
                                  '${member['intimacyPercent']}%',
                                );
                              })
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // 최근 퀴즈 정답
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      Obx(
                        () => Column(
                          children: controller.recentQuizzes
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final quiz = entry.value;
                                return _buildQuizItem(
                                  quiz['question'],
                                  quiz['answer'],
                                  quiz['date'],
                                  index,
                                );
                              })
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: controller.goToQuiz,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
