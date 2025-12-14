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
  final RxBool showEmailInput = false.obs;
  final Rx<VillageMember?> currentUserRole = Rx<VillageMember?>(null);
  final RxBool isLoadingRole = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserRole();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
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

  void editDescription() {
    // TODO: 마을 설명 수정 기능
    Get.snackbar('준비 중', '마을 설명 수정 기능은 준비 중입니다');
  }
}
