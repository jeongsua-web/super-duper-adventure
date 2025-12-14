import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/invitation_service.dart';
import '../../../models/village_member.dart';
import '../../../services/village_role_service.dart';

class InvitationCreateController extends GetxController {
  final String villageId;
  final String villageName;

  InvitationCreateController({
    required this.villageId,
    required this.villageName,
  });

  final InvitationService _invitationService = InvitationService();
  final VillageRoleService _roleService = VillageRoleService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxString generatedCode = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final role = await _roleService.getUserRole(villageId, user.uid);
    hasPermission.value = role?.hasPermission(VillagePermission.inviteMembers) ?? false;
  }

  Future<void> generateInvitationCode() async {
    final user = _auth.currentUser;
    if (user == null) return;

    isLoading.value = true;

    try {
      final code = await _invitationService.createInvitation(
        villageId: villageId,
        createdBy: user.uid,
        expiresIn: const Duration(days: 7),
      );

      generatedCode.value = code;
    } catch (e) {
      Get.snackbar('오류', '초대 코드 생성 실패: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void copyToClipboard() {
    if (generatedCode.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: generatedCode.value));
      Get.snackbar('성공', '초대 코드가 복사되었습니다');
    }
  }

  void shareInvitationLink() {
    if (generatedCode.value.isNotEmpty) {
      final link = _invitationService.getInvitationLink(generatedCode.value);
      Clipboard.setData(ClipboardData(text: link));
      Get.snackbar('성공', '초대 링크가 복사되었습니다');
    }
  }

  void resetCode() {
    generatedCode.value = '';
  }

  void goBack() {
    Get.back();
  }

  void goToInvitationList() {
    // TODO: 초대 코드 목록 화면으로 이동
    Get.snackbar('준비 중', '초대 코드 목록 기능은 준비 중입니다');
  }
}
