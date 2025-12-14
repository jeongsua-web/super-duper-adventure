import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/invitation_service.dart';

class InvitationInputController extends GetxController {
  final InvitationService _invitationService = InvitationService();

  final TextEditingController codeController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void onCodeChanged(String value) {
    if (errorMessage.value.isNotEmpty) {
      errorMessage.value = '';
    }
    // 자동으로 대문자 변환
    if (value != value.toUpperCase()) {
      codeController.value = codeController.value.copyWith(
        text: value.toUpperCase(),
        selection: TextSelection.collapsed(
          offset: value.length,
        ),
      );
    }
  }

  Future<void> validateAndProceed() async {
    final code = codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      errorMessage.value = '초대 코드를 입력해주세요';
      return;
    }

    if (code.length != 6) {
      errorMessage.value = '초대 코드는 6자리입니다';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final invitationData = await _invitationService.validateInvitation(code);

      if (invitationData == null) {
        errorMessage.value = '유효하지 않거나 만료된 초대 코드입니다';
        isLoading.value = false;
        return;
      }

      // 초대장 화면으로 이동
      final result = await Get.toNamed(
        '/village-invitation',
        arguments: {'invitationCode': code},
      );

      if (result == true) {
        // 입주 성공 시 뒤로 가기
        Get.back(result: true);
      }
    } catch (e) {
      errorMessage.value = '오류가 발생했습니다: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }
}
