import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/village_invitation_controller.dart';

class VillageInvitationView extends GetView<VillageInvitationController> {
  const VillageInvitationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      // 초대장 배경
                      Positioned(
                        left: 47,
                        top: 50,
                        child: Container(
                          width: 301,
                          height: 795,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE7E7E7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // 뒤로가기 버튼
                      Positioned(
                        left: 16,
                        top: 16,
                        child: GestureDetector(
                          onTap: controller.decline,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.arrow_back, size: 24),
                          ),
                        ),
                      ),

                      // 초대장 제목
                      const Positioned(
                        left: 168,
                        top: 107,
                        child: Text(
                          '초대장',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontFamily: 'Bagel Fat One',
                            fontWeight: FontWeight.w400,
                            height: 1.125,
                            letterSpacing: 0.32,
                          ),
                        ),
                      ),

                      // 초대 메시지 박스
                      Positioned(
                        left: 64,
                        top: 163,
                        child: Container(
                          width: 267,
                          height: 170,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Obx(
                                () => Text(
                                  '${controller.creatorName.value ?? 'OO'}님께\n당신을 ${controller.villageName ?? '마을'}에 초대합니다',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.80,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 마을 설명 라벨
                      const Positioned(
                        left: 64,
                        top: 360,
                        child: Text(
                          '마을 설명',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ),

                      // 마을 설명 박스
                      Positioned(
                        left: 64,
                        top: 378,
                        child: Container(
                          width: 267,
                          height: 92,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              child: Obx(
                                () => Text(
                                  controller.villageDescription.value,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.80,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 서명 라벨
                      const Positioned(
                        left: 252,
                        top: 489,
                        child: Text(
                          '서명',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ),

                      // 생성자 이름 표시
                      Positioned(
                        left: 227,
                        top: 507,
                        child: Container(
                          width: 72,
                          height: 54,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Center(
                            child: Obx(
                              () => Text(
                                controller.creatorName.value ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.80,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 입주 확인 메시지
                      const Positioned(
                        left: 113,
                        top: 575,
                        child: Text(
                          '입주하시겠습니까?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ),

                      // 닉네임 입력 필드
                      Positioned(
                        left: 96,
                        top: 600,
                        child: SizedBox(
                          width: 205,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '닉네임 (선택)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.nicknameController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    hintText: '닉네임 입력',
                                    hintStyle: TextStyle(fontSize: 10),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 수락 버튼
                      Positioned(
                        left: 96,
                        top: 680,
                        child: GestureDetector(
                          onTap: () {
                            if (!controller.isLoading.value) {
                              controller.acceptInvitation();
                            }
                          },
                          child: Container(
                            width: 205,
                            height: 45,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFC4ECF6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Obx(
                                () => controller.isLoading.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.black,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        '입주하기',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Gowun Dodum',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 거절 버튼
                      Positioned(
                        left: 96,
                        top: 735,
                        child: GestureDetector(
                          onTap: controller.decline,
                          child: Container(
                            width: 205,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '거절하기',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
