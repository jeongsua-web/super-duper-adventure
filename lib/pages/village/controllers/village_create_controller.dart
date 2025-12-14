import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../../services/village_role_service.dart';

class VillageCreateController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final VillageRoleService _roleService = VillageRoleService();

  final TextEditingController villageNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxBool isLoading = false.obs;
  final Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);
  final RxString base64Image = ''.obs;

  @override
  void onClose() {
    villageNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 50,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        selectedImageBytes.value = bytes;
        base64Image.value = base64Encode(bytes);
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
      Get.snackbar('오류', '이미지를 불러오지 못했습니다.');
    }
  }

  Future<void> createVillage() async {
    final villageName = villageNameController.text.trim();
    final description = descriptionController.text.trim();

    if (villageName.isEmpty) {
      Get.snackbar('입력 오류', '마을 이름을 입력해주세요');
      return;
    }

    isLoading.value = true;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 사용자가 이미 생성한 마을이 있는지 확인
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data()?['villages'] != null) {
        final villages = userDoc.data()!['villages'];
        if (villages is List && villages.isNotEmpty) {
          Get.snackbar('제한', '한 사람당 하나의 마을만 생성할 수 있습니다');
          isLoading.value = false;
          return;
        }
      }

      // Firestore에 마을 정보 저장
      final villageRef = await _firestore.collection('villages').add({
        'name': villageName,
        'description': description,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'memberCount': 1,
        'image': base64Image.value.isEmpty ? null : base64Image.value,
      });

      // 생성자 역할 부여
      await _roleService.setCreatorRole(villageRef.id, user.uid);

      // 사용자 정보 업데이트
      await _firestore.collection('users').doc(user.uid).set({
        'villages': FieldValue.arrayUnion([villageRef.id]),
      }, SetOptions(merge: true));

      Get.snackbar('성공', '마을이 생성되었습니다!');
      // 홈(메인홈)으로 이동
      Get.offAllNamed('/main-home');
    } catch (e) {
      Get.snackbar('오류', '마을 생성 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
