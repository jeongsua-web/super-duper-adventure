import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/post_create_controller.dart';

class PostCreateView extends GetView<PostCreateController> {
  const PostCreateView({super.key});

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
                  // 헤더 (X, 제목, 완료 버튼)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: controller.goBack,
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Text(
                          controller.villageName,
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.isLoading.value
                                ? null
                                : controller.savePost,
                            child: Icon(
                              Icons.edit,
                              color: controller.isLoading.value
                                  ? Colors.grey
                                  : Colors.white,
                              size: 28,
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

          // 컨텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 선택
                  Text(
                    '게시판 선택',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<String>(
                        value: controller.selectedCategory.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: controller.categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: controller.updateCategory,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 제목 입력
                  TextField(
                    controller: controller.titleController,
                    decoration: InputDecoration(
                      hintText: '글 제목을 입력하세요.',
                      hintStyle: GoogleFonts.gowunDodum(
                        color: const Color(0xFFAAAAAA),
                        fontSize: 16,
                      ),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 내용 입력
                  TextField(
                    controller: controller.contentController,
                    decoration: InputDecoration(
                      hintText: '글 내용을 입력하세요.',
                      hintStyle: GoogleFonts.gowunDodum(
                        color: const Color(0xFFAAAAAA),
                        fontSize: 16,
                      ),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(
                    Icons.camera_alt,
                    controller.onCameraPressed,
                  ),
                  _buildBottomButton(
                    Icons.attach_file,
                    controller.onAttachPressed,
                  ),
                  _buildBottomButton(
                    Icons.text_fields,
                    controller.onTextFormatPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }
}
