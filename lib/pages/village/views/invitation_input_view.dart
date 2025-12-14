import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/invitation_input_controller.dart';

class InvitationInputView extends GetView<InvitationInputController> {
  const InvitationInputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: controller.goBack,
        ),
        title: const Text(
          '초대 코드 입력',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Gowun Dodum',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              '마을 초대 코드를\n입력하세요',
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Gowun Dodum',
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '생성자로부터 받은 6자리 코드를 입력해주세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Gowun Dodum',
              ),
            ),
            const SizedBox(height: 40),

            // 초대 코드 입력 필드
            TextField(
              controller: controller.codeController,
              textAlign: TextAlign.center,
              maxLength: 6,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                fontFamily: 'Courier New',
              ),
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: TextStyle(
                  color: Colors.grey[300],
                  letterSpacing: 8,
                ),
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFC4ECF6),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
              ),
              onChanged: controller.onCodeChanged,
              onSubmitted: (_) => controller.validateAndProceed(),
            ),

            // 에러 메시지
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontFamily: 'Gowun Dodum',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 32),

            // 확인 버튼
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.validateAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4ECF6),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),

            const Spacer(),

            // 안내 문구
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '초대 코드가 없으신가요?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          fontFamily: 'Gowun Dodum',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '마을 생성자에게 초대 코드를 요청하거나\n직접 새로운 마을을 만들 수 있습니다.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.6,
                      fontFamily: 'Gowun Dodum',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
