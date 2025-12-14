import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/village_settings_controller.dart';

class VillageSettingsView extends GetView<VillageSettingsController> {
  const VillageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRole.value || controller.isLoadingData.value) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.currentUserRole.value?.isCreator != true) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: Text('접근 권한이 없습니다')),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: controller.goBack,
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          ),
          leadingWidth: 60,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 마을 정보 섹션
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '마을 정보',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '마을 설명',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (!controller.isEditingDescription.value)
                              GestureDetector(
                                onTap: controller.startEditingDescription,
                                child: Text(
                                  '수정',
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            if (controller.isEditingDescription.value)
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: controller.saveDescription,
                                    child: Text(
                                      '저장',
                                      style: GoogleFonts.gowunDodum(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: controller.cancelEditingDescription,
                                    child: Text(
                                      '취소',
                                      style: GoogleFonts.gowunDodum(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF4DDBFF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: controller.isEditingDescription.value
                                ? TextField(
                                    controller: controller.descriptionController,
                                    minLines: 1,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  )
                                : Text(
                                    controller.villageDescription.value.isEmpty
                                        ? '마을 설명이 없습니다'
                                        : controller.villageDescription.value,
                                    style: GoogleFonts.gowunDodum(
                                      color: controller.villageDescription.value.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 초대장 섹션
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '초대장 보내기',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 32),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF4DDBFF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: controller.showEmailInput.value
                                ? TextField(
                                    controller: controller.emailController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '이메일 입력',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 0,
                                      ),
                                    ),
                                    style: GoogleFonts.gowunDodum(fontSize: 14),
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'design/4N6oqrDpi0nSrF8ct0',
                                      style: GoogleFonts.gowunDodum(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                          GestureDetector(
                            onTap: controller.showEmailInput.value
                                ? controller.sendInvitation
                                : () => controller.showEmailInput.value = true,
                            child: Text(
                              controller.showEmailInput.value ? '보내기' : '초대하기',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 주민 목록 섹션
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '주민 목록',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 40),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF4DDBFF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.residents.isEmpty
                          ? Text(
                              '주민이 없습니다',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Text(
                              controller.residents
                                  .map((r) => r['name'] as String)
                                  .join('\n'),
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                height: 2,
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
    });
  }
}
