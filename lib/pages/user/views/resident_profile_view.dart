import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resident_profile_controller.dart';

class ResidentProfileView extends StatelessWidget {
  final String residentName;

  const ResidentProfileView({super.key, this.residentName = '주민'});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResidentProfileController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFE8D7C3),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top Header Section
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF87CEEB),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile section with avatar and info
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Profile avatar
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Text info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        residentName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '마을 관리자와의 친밀도',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Progress bar
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: 0.8,
                                          minHeight: 12,
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.pink.shade200,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '80%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Room area with furniture
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: const Color(0xFFE8D7C3),
                        child: Stack(
                          children: [
                            // Wardrobe (옷장)
                            Positioned(
                              top: 30,
                              left: 20,
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB8860B),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Left door
                                        Container(
                                          width: 40,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDEB887),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.circle,
                                              size: 8,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Right door
                                        Container(
                                          width: 40,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDEB887),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.circle,
                                              size: 8,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 100,
                                    height: 8,
                                    color: const Color(0xFF8B7355),
                                  ),
                                ],
                              ),
                            ),
                            // Desk (책상)
                            Positioned(
                              bottom: 40,
                              right: 30,
                              child: SizedBox(
                                width: 120,
                                height: 62,
                                child: Stack(
                                  children: [
                                    // Table top
                                    Container(
                                      width: 120,
                                      height: 12,
                                      color: const Color(0xFF8B4513),
                                    ),
                                    // Left leg
                                    Positioned(
                                      left: 0,
                                      top: 12,
                                      child: Container(
                                        width: 8,
                                        height: 50,
                                        color: const Color(0xFF654321),
                                      ),
                                    ),
                                    // Right leg
                                    Positioned(
                                      right: 0,
                                      top: 12,
                                      child: Container(
                                        width: 8,
                                        height: 50,
                                        color: const Color(0xFF654321),
                                      ),
                                    ),
                                  ],
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
              // Action buttons and Back button
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFF87CEEB)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: controller.goBack,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            '밖으로',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToGuestbook,
                      child: const Text(
                        '방명록 쓰러 가기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
