import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/village_role_service.dart';

class VillageInvitationController extends GetxController {
  final String invitationCode;
  final String? villageName;
  final String? invitationMessage;

  VillageInvitationController({
    required this.invitationCode,
    this.villageName,
    this.invitationMessage,
  });

  final nicknameController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final RxBool isLoading = true.obs;
  final Rx<String?> villageId = Rx<String?>(null);
  final RxString villageDescription = ''.obs;
  final Rx<String?> creatorName = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadInvitationData();
  }

  @override
  void onClose() {
    nicknameController.dispose();
    super.onClose();
  }

  Future<void> loadInvitationData() async {
    try {
      isLoading.value = true;

      // 초대장 문서 조회
      final invitationDoc =
          await _firestore.collection('invitations').doc(invitationCode).get();

      if (!invitationDoc.exists) {
        Get.back();
        Get.snackbar('오류', '유효하지 않은 초대 코드입니다.');
        return;
      }

      final invitationData = invitationDoc.data()!;
      villageId.value = invitationData['villageId'] as String?;

      if (villageId.value == null) {
        Get.back();
        Get.snackbar('오류', '마을 정보를 찾을 수 없습니다.');
        return;
      }

      // 마을 문서 조회
      final villageDoc =
          await _firestore.collection('villages').doc(villageId.value).get();

      if (!villageDoc.exists) {
        Get.back();
        Get.snackbar('오류', '마을이 존재하지 않습니다.');
        return;
      }

      final villageData = villageDoc.data()!;
      villageDescription.value =
          villageData['description'] as String? ?? '설명 없음';
      final createdBy = villageData['createdBy'] as String?;

      // 생성자 이름 조회
      if (createdBy != null) {
        final userDoc = await _firestore.collection('users').doc(createdBy).get();
        if (userDoc.exists) {
          creatorName.value = userDoc.data()?['name'] as String? ?? '알 수 없음';
        }
      }
    } catch (e) {
      Get.back();
      Get.snackbar('오류', '초대 정보를 불러오는 중 오류가 발생했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptInvitation() async {
    final user = _auth.currentUser;
    if (user == null || villageId.value == null) {
      Get.snackbar('오류', '로그인이 필요합니다.');
      return;
    }

    try {
      isLoading.value = true;

      // VillageRoleService를 사용하여 멤버 추가
      final roleService = VillageRoleService();
      await roleService.addMember(
        villageId.value!,
        user.uid,
      );

      // 사용자 문서의 villages 배열에 추가
      await _firestore.collection('users').doc(user.uid).update({
        'villages': FieldValue.arrayUnion([villageId.value]),
      });

      // 마을 memberCount 증가
      await _firestore.collection('villages').doc(villageId.value).update({
        'memberCount': FieldValue.increment(1),
      });

      Get.back();
      Get.snackbar('성공', '마을에 입주했습니다!');
    } catch (e) {
      Get.snackbar('오류', '입주 처리 중 오류가 발생했습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void decline() {
    Get.back();
  }
}
