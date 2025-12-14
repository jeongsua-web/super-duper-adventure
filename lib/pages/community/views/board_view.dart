import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../home/views/main_home_view.dart';
import '../controllers/board_controller.dart';
import '../../../routes/app_routes.dart';
import 'search_view.dart';
import 'board_list_view.dart';

class BoardView extends GetView<BoardController> {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BoardScreen(
      villageName: controller.villageName,
      villageId: controller.villageId,
    );
  }
}

class BoardScreen extends StatefulWidget {
  final String villageName; // 화면에 보여줄 마을 이름
  final String villageId; // [필수] 데이터베이스에서 사용할 마을 ID

  const BoardScreen({
    super.key,
    required this.villageName,
    required this.villageId,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String _selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // 그라디언트 배경
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
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
              right: 0,
              child: Container(
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
                      onTap: () {
                        Get.toNamed(AppRoutes.village);
                      },
                      child: Text(
                        widget.villageName,
                        style: GoogleFonts.gowunDodum(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.search,
                          arguments: {'villageName': widget.villageName},
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 마이마을 텍스트
            Positioned(
              left: 16,
              top: 59,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainHomeView(),
                    ),
                  );
                },
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
            Positioned(
              left: 43,
              top: 383,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => BoardListView(
                      category: '전체',
                      villageName: widget.villageName,
                      villageId: widget.villageId,
                    ),
                  );
                },
                child: Text(
                  '전체',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '전체'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 460,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => BoardListView(
                      category: '일상',
                      villageName: widget.villageName,
                      villageId: widget.villageId,
                    ),
                  );
                },
                child: Text(
                  '일상',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '일상'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 531,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => BoardListView(
                      category: '게임',
                      villageName: widget.villageName,
                      villageId: widget.villageId,
                    ),
                  );
                },
                child: Text(
                  '게임',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '게임'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 43,
              top: 602,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => BoardListView(
                      category: '취미',
                      villageName: widget.villageName,
                      villageId: widget.villageId,
                    ),
                  );
                },
                child: Text(
                  '취미',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '취미'
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 42,
              top: 673,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.quiz,
                    arguments: {
                      'villageName': widget.villageName,
                      'villageId': widget.villageId,
                    },
                  );
                },
                child: Text(
                  '퀴즈',
                  style: GoogleFonts.gowunDodum(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: _selectedCategory == '퀴즈'
                        ? FontWeight.w700
                        : FontWeight.w400,
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
