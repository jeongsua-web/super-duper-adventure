import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/invitation_create_controller.dart';

class InvitationCreateView extends GetView<InvitationCreateController> {
  const InvitationCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasPermission.value) {
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
              '초대 코드 생성',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Gowun Dodum',
              ),
            ),
          ),
          body: const Center(
            child: Text(
              '초대 코드를 생성할 권한이 없습니다',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gowun Dodum',
              ),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: controller.goBack,
          ),
          title: Text(
            '${controller.villageName} 초대',
            style: const TextStyle(
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
                '마을에 초대할\n초대 코드를 생성하세요',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '초대 코드는 7일간 유효합니다',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'Gowun Dodum',
                ),
              ),
              const SizedBox(height: 40),

              // 초대 코드 생성 버튼
              Obx(() {
                if (controller.generatedCode.value.isEmpty) {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.generateInvitationCode,
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : const Text(
                            '초대 코드 생성하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // 생성된 초대 코드 표시
              Obx(() {
                if (controller.generatedCode.value.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFC4ECF6),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '초대 코드',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontFamily: 'Gowun Dodum',
                              ),
                            ),
                            const SizedBox(height: 12),
                            SelectableText(
                              controller.generatedCode.value,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                fontFamily: 'Courier New',
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: controller.copyToClipboard,
                                  icon: const Icon(Icons.copy, size: 18),
                                  label: const Text('복사'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black26),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: controller.shareInvitationLink,
                                  icon: const Icon(Icons.share, size: 18),
                                  label: const Text('링크 공유'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC4ECF6),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: controller.resetCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '새 코드 생성',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gowun Dodum',
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 40),

              // 안내 사항
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 20, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          '초대 코드 안내',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                            fontFamily: 'Gowun Dodum',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• 초대 코드는 7일간 유효합니다\n'
                      '• 여러 사람이 같은 코드로 입주할 수 있습니다\n'
                      '• 초대 코드 목록에서 관리할 수 있습니다',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.6,
                        fontFamily: 'Gowun Dodum',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 초대 코드 목록 버튼
              TextButton.icon(
                onPressed: controller.goToInvitationList,
                icon: const Icon(Icons.list),
                label: const Text('생성된 초대 코드 목록'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black54,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
