import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../community/controllers/board_controller.dart';
import '../../community/views/board_view.dart';
import '../../community/controllers/calendar_controller.dart';
import '../../community/views/calendar_view.dart';
import '../../community/controllers/chat_list_controller.dart';
import '../../community/views/chat_list_view.dart';
import '../../user/controllers/resident_profile_controller.dart';
import '../../user/views/resident_profile_view.dart';
import '../../user/controllers/creator_home_controller.dart';
import '../../user/views/creator_home_view.dart';
import '../controllers/village_view_controller.dart';

class VillageDashboardView extends GetView<VillageViewController> {
  const VillageDashboardView({super.key});

  void _openCategory(String category) {
    if (category == '주민집') {
      // TODO: 주민 목록에서 선택하도록 변경 필요
      // 임시로 현재 사용자의 프로필을 표시
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        Get.snackbar('오류', '로그인이 필요합니다');
        return;
      }

      Get.to(
        () => const ResidentProfileView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(
            () => ResidentProfileController(
              userId: currentUserId,
              villageName: controller.villageName ?? '마을',
            ),
          );
        }),
      );
    } else if (category == '게시판') {
      Get.to(
        () => const BoardView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(
            () => BoardController(
              villageName: controller.villageName ?? '마을',
              villageId: controller.resolvedVillageId.value ?? '',
            ),
          );
        }),
      );
    } else if (category == '마을 생성자 집') {
      Get.to(
        () => const CreatorHomeView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(
            () => CreatorHomeController(
              villageName: controller.villageName ?? '마을',
            ),
          );
        }),
      );
    } else if (category == '캘린더') {
      Get.to(
        () => const CalendarView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(
            () => CalendarController(
              villageName: controller.villageName ?? '마을',
              villageId: controller.resolvedVillageId.value,
            ),
          );
        }),
      );
    } else if (category == '채팅') {
      Get.to(
        () => const ChatListView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => ChatListController());
        }),
      );
    } else {
      Get.snackbar('알림', '$category 페이지로 이동');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 상단 바
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: controller.goBack,
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      controller.villageName ?? '마을',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: controller.goToTileMap,
                          child: const Icon(
                            Icons.map,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: controller.goToSettings,
                          child: const Icon(
                            Icons.settings,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 그리드 버튼들
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 21),
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _VillageCell(
                        label: '주민집',
                        onTap: () => _openCategory('주민집'),
                      ),
                      _VillageCell(
                        label: '마을 생성자 집',
                        fontSize: 16,
                        onTap: () => _openCategory('마을 생성자 집'),
                      ),
                      _VillageCell(label: '', onTap: () {}),
                      _VillageCell(
                        label: '채팅',
                        onTap: () => _openCategory('채팅'),
                      ),
                      _VillageCell(
                        label: '게시판',
                        onTap: () => _openCategory('게시판'),
                      ),
                      _VillageCell(
                        label: '캘린더',
                        onTap: () => _openCategory('캘린더'),
                      ),
                      _VillageCell(label: '', onTap: () {}),
                      _VillageCell(label: '', onTap: () {}),
                      _VillageCell(label: '', onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}

class _VillageCell extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double fontSize;

  const _VillageCell({
    required this.label,
    required this.onTap,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: label.isNotEmpty ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4CDBFF), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
