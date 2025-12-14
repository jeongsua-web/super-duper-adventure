import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/creator_home_controller.dart';

class CreatorHomeView extends GetView<CreatorHomeController> {
  const CreatorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main container with rounded background
            Positioned(
              left: 9,
              top: 125,
              child: Container(
                width: 374,
                height: 750,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(43),
                ),
              ),
            ),

            // Back button (top left)
            Positioned(
              left: 16,
              top: 12,
              child: GestureDetector(
                onTap: controller.goBack,
                child: Container(
                  width: 63,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Profile circle (top center)
            Positioned(
              left: 126,
              top: 44,
              child: Container(
                width: 142,
                height: 142,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),

            // Profile title
            const Positioned(
              left: 141,
              top: 105,
              child: Text(
                '프로필',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  height: 0.45,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Name button/box
            Positioned(
              left: 88,
              top: 169,
              child: Container(
                width: 215,
                height: 53,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC5C5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    '이름',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      height: 0.45,
                      letterSpacing: 0.01,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // First info box - 전체 주민 친밀도 순위
            Positioned(
              left: 23,
              top: 239,
              child: GestureDetector(
                onTap: controller.showMemberRankings,
                child: Container(
                  width: 346,
                  height: 244,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      '전체 주민\n친밀도 순위',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 34,
                        height: 1.176,
                        letterSpacing: 0.01,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Second info box - 관리자에 대한 모든 것
            Positioned(
              left: 23,
              top: 508,
              child: GestureDetector(
                onTap: controller.showQuizAnswers,
                child: Container(
                  width: 346,
                  height: 244,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      '관리자에 대한\n모든 것\n(역대 퀴즈 정답)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 34,
                        height: 1.176,
                        letterSpacing: 0.01,
                        color: Colors.black,
                      ),
                    ),
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
