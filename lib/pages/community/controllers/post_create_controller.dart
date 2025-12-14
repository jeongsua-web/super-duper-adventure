import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostCreateController extends GetxController {
  final String villageName;
  final String villageId;

  PostCreateController({
    required this.villageName,
    required this.villageId,
  });

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = '일상'.obs;
  final RxList<String> categories = <String>['일상', '게임', '취미'].obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isNotice = false.obs;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  // 이미지 선택
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        '오류',
        '이미지 선택 실패: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 카테고리 변경
  void updateCategory(String? newCategory) {
    if (newCategory != null) {
      selectedCategory.value = newCategory;
    }
  }

  // 게시글 저장
  Future<void> savePost() async {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        '알림',
        '제목을 입력해주세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl;

      // 이미지 업로드
      if (selectedImage.value != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child(fileName);

        await storageRef.putFile(selectedImage.value!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Firestore에 저장
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('posts')
          .add({
        'title': titleController.text,
        'content': contentController.text,
        'category': selectedCategory.value,
        'author': '익명',
        'createdAt': FieldValue.serverTimestamp(),
        'isNotice': isNotice.value,
        'imageUrl': imageUrl,
      });

      Get.back(result: true);
      Get.snackbar(
        '성공',
        '게시글이 작성되었습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '오류',
        '게시글 저장 실패: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 뒤로가기
  void goBack() {
    Get.back();
  }

  // 카메라 버튼 (이미지 선택과 동일)
  void onCameraPressed() {
    pickImage();
  }

  // 첨부파일 버튼
  void onAttachPressed() {
    Get.snackbar(
      '준비 중',
      '파일 첨부 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // 텍스트 서식 버튼
  void onTextFormatPressed() {
    Get.snackbar(
      '준비 중',
      '텍스트 서식 기능은 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
