import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/quiz_controller.dart';
import 'quiz_create_view.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

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
                            onTap: controller.goToMainHome,
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
                            onTap: controller.goToVillageView,
                            child: Text(
                              controller.villageName,
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        // 오른쪽: 글쓰기 아이콘
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  QuizCreateScreen(
                                    villageName: controller.villageName,
                                  ),
                                );
                              },
                              child: Icon(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    // 진행중인 퀴즈 섹션
                    Text(
                      '진행중인 퀴즈',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Obx(
                      () => Column(
                        children: controller.activeQuizzes.map((quiz) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFC4ECF6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quiz['title'],
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  quiz['description'],
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.startQuiz(quiz['id']),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            23,
                                          ),
                                        ),
                                      ),
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
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 종료된 퀴즈 섹션
                    Text(
                      '종료된 퀴즈',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Obx(
                      () => Column(
                        children: controller.completedQuizzes.map((quiz) {
                          return GestureDetector(
                            onTap: () => controller.viewQuizResult(quiz['id']),
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFC4ECF6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    quiz['title'],
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    quiz['date'],
                                    style: GoogleFonts.gowunDodum(
                                      color: const Color(0xFF595959),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
