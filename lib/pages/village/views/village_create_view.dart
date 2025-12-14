import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/village_create_controller.dart';

class VillageCreateView extends GetView<VillageCreateController> {
  const VillageCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '새 마을 만들기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Gowun Dodum',
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 마을 대표 이미지 선택 영역
              Center(
                child: Obx(() => GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                      image: controller.selectedImageBytes.value != null
                          ? DecorationImage(
                              image: MemoryImage(
                                controller.selectedImageBytes.value!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: controller.selectedImageBytes.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '마을 대표 사진 등록',
                                style: TextStyle(
                                  fontFamily: 'Gowun Dodum',
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                )),
              ),

              const SizedBox(height: 30),

              const Text(
                '마을 이름',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.villageNameController,
                decoration: InputDecoration(
                  hintText: '마을 이름을 입력하세요',
                  filled: true,
                  fillColor: const Color(0xFFE7E7E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Gowun Dodum',
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '마을 소개 (선택)',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '마을에 대한 간단한 소개를 작성해주세요',
                  filled: true,
                  fillColor: const Color(0xFFE7E7E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Gowun Dodum',
                ),
              ),
              const SizedBox(height: 40),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.createVillage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC4ECF6),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          '마을 만들기',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
