import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/village_role_service.dart';
import '../../../models/village_member.dart';

class VillageSettingsController extends GetxController {
  final String villageId;
  final String villageName;

  VillageSettingsController({
    required this.villageId,
    required this.villageName,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VillageRoleService _roleService = VillageRoleService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxBool showEmailInput = false.obs;
  final RxBool isEditingDescription = false.obs;
  final Rx<VillageMember?> currentUserRole = Rx<VillageMember?>(null);
  final RxBool isLoadingRole = true.obs;
  final RxBool isLoadingData = true.obs;
  final RxString villageDescription = ''.obs;
  final RxList<Map<String, dynamic>> residents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
    _loadVillageData();
    _loadResidents();
  }

  @override
  void onClose() {
    emailController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> _loadVillageData() async {
    try {
      final doc = await _firestore.collection('villages').doc(villageId).get();
      if (doc.exists) {
        final data = doc.data();
        villageDescription.value = data?['description'] ?? '';
        descriptionController.text = villageDescription.value;
      }
      isLoadingData.value = false;
    } catch (e) {
      print('마을 데이터 로드 오류: $e');
      isLoadingData.value = false;
    }
  }

  Future<void> _loadResidents() async {
    try {
      final membersSnapshot = await _firestore
          .collection('villages')
          .doc(villageId)
          .collection('members')
          .get();

      final List<Map<String, dynamic>> residentList = [];

      for (var memberDoc in membersSnapshot.docs) {
        final userId = memberDoc.id;
        final userDoc = await _firestore.collection('users').doc(userId).get();
        
        if (userDoc.exists) {
          final userData = userDoc.data();
          final memberData = memberDoc.data();
          residentList.add({
            'id': userId,
            'name': userData?['name'] ?? '알 수 없음',
            'email': userData?['email'] ?? '',
            'role': memberData['role'] ?? 'resident',
          });
        }
      }

      residents.value = residentList;
    } catch (e) {
      print('주민 목록 로드 오류: $e');
    }
  }

  Future<void> _loadUserRole() async {
    try {
      final role = await _roleService.getCurrentUserRole(villageId);
      currentUserRole.value = role;
      isLoadingRole.value = false;

      if (role?.isCreator != true) {
        Get.snackbar('권한 없음', '마을 생성자만 설정을 변경할 수 있습니다');
        Get.back();
      }
    } catch (e) {
      print('권한 로드 오류: $e');
      isLoadingRole.value = false;
    }
  }

  Future<void> sendInvitation() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('입력 오류', '이메일을 입력해주세요');
      return;
    }

    if (!email.contains('@')) {
      Get.snackbar('형식 오류', '올바른 이메일 형식을 입력해주세요');
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('invitations').add({
        'villageId': villageId,
        'villageName': villageName,
        'recipientEmail': email,
        'senderEmail': user.email,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('성공', '$email로 초대장을 보냈습니다');

      emailController.clear();
      showEmailInput.value = false;
    } catch (e) {
      Get.snackbar('오류', '초대장 전송 실패: $e');
    }
  }

  void toggleEmailInput() {
    if (showEmailInput.value) {
      sendInvitation();
    } else {
      showEmailInput.value = true;
    }
  }

  void goBack() {
    Get.back();
  }

  void startEditingDescription() {
    isEditingDescription.value = true;
  }

  void cancelEditingDescription() {
    descriptionController.text = villageDescription.value;
    isEditingDescription.value = false;
  }

  Future<void> saveDescription() async {
    try {
      await _firestore
          .collection('villages')
          .doc(villageId)
          .update({'description': descriptionController.text});

      villageDescription.value = descriptionController.text;
      isEditingDescription.value = false;
      Get.snackbar('성공', '마을 설명이 저장되었습니다');
    } catch (e) {
      Get.snackbar('오류', '저장 실패: $e');
    }
  }
}
