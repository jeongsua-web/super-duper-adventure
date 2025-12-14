import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:convert';
import '../controllers/main_home_controller.dart';

class MainHomeView extends GetView<MainHomeController> {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // 로그인 안 되어 있으면
        if (!controller.isUserLoggedIn.value) {
          return const Center(child: Text("로그인이 필요합니다."));
        }

        return SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  
                  // 상단바
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Obx(() => Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: '어서오세요 ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: '${controller.userName.value}님!',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _CustomTopButton(
                              label: '메뉴',
                              iconData: Icons.menu,
                              onTap: controller.navigateToSettings,
                            ),
                            _CustomTopButton(
                              label: '우편함',
                              iconData: Icons.mark_as_unread_sharp,
                              onTap: controller.navigateToMailbox,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 안내 문구
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '어느 마을로 이동할까요? 🏡',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  // 중앙 영역 (마을 카드)
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (controller.villages.isEmpty) {
                        return _buildNoVillageCard();
                      }
                      
                      if (controller.pageController.value == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse
                          },
                        ),
                        child: SizedBox(
                          height: 340,
                          child: PageView.builder(
                            controller: controller.pageController.value,
                            itemCount: controller.villages.length > 1 ? null : 1,
                            onPageChanged: controller.onPageChanged,
                            itemBuilder: (context, index) {
                              final int actualIndex = index % controller.villages.length;
                              final villageData = controller.villages[actualIndex];
                              
                              return Obx(() => _VillageCard(
                                title: villageData['name'],
                                creator: villageData['creator'] ?? '촌장님',
                                villageId: villageData['id'],
                                imageData: villageData['image'],
                                isCenter: index == controller.currentIndex.value,
                                onTap: () => controller.navigateToVillage(
                                  villageData['id'],
                                  villageData['name'],
                                ),
                              ));
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 160),
                ],
              ),

              // 하단 바
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 160,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFC4ECF6), Color(0xFFB3E5FC)],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.home_filled,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: controller.goToHome,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: controller.navigateToSettings,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // MY마을 버튼
                      Positioned(
                        bottom: 35,
                        child: GestureDetector(
                          onTap: controller.onMyVillageTap,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'MY마을',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNoVillageCard() {
    return Center(
      child: Container(
        height: 300,
        width: 250,
        decoration: BoxDecoration(
          color: const Color(0xFFC4ECF6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_home_work_outlined,
              size: 70,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              '가입된 마을이 없습니다',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gowun Dodum',
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: controller.navigateToCreateVillage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '새 마을 만들기',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTopButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  
  const _CustomTopButton({
    required this.label,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 40,
            decoration: const BoxDecoration(),
            child: Icon(iconData, size: 36, color: const Color(0xFFC4ECF6)),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Gowun Dodum',
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _VillageCard extends StatelessWidget {
  final String title;
  final String creator;
  final String villageId;
  final String? imageData;
  final bool isCenter;
  final VoidCallback onTap;

  const _VillageCard({
    required this.title,
    required this.creator,
    required this.villageId,
    this.imageData,
    required this.isCenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double height = isCenter ? 300 : 270;
    const Color bgColor = Color(0xFFC4ECF6);

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageData != null && imageData!.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(
                                base64Decode(imageData!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'Gowun Dodum',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_city_rounded,
                                  size: 70,
                                  color: Color(0xFFBCBCBC),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  alignment: Alignment.center,
                  child: Text(
                    '$creator 님의 마을',
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Gowun Dodum',
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
