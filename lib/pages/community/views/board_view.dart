import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/board_controller.dart';

class BoardView extends GetView<BoardController> {
  const BoardView({super.key});

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
                onTap: controller.goToMainHome,
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
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 383),
                _CategoryButton(
                  category: '전체',
                  isSelected: controller.selectedCategory.value == '전체',
                  onTap: () => controller.goToBoardList('전체'),
                ),
                const SizedBox(height: 73),
                _CategoryButton(
                  category: '일상',
                  isSelected: controller.selectedCategory.value == '일상',
                  onTap: () => controller.goToBoardList('일상'),
                ),
                const SizedBox(height: 73),
                _CategoryButton(
                  category: '게임',
                  isSelected: controller.selectedCategory.value == '게임',
                  onTap: () => controller.goToBoardList('게임'),
                ),
                const SizedBox(height: 73),
                _CategoryButton(
                  category: '취미',
                  isSelected: controller.selectedCategory.value == '취미',
                  onTap: () => controller.goToBoardList('취미'),
                ),
                const SizedBox(height: 73),
                _CategoryButton(
                  category: '퀴즈',
                  isSelected: controller.selectedCategory.value == '퀴즈',
                  onTap: controller.goToQuiz,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 43),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          category,
          style: GoogleFonts.gowunDodum(
            color: Colors.black,
            fontSize: 28,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
