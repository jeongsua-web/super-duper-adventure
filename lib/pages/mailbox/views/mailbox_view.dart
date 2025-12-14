import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mailbox_controller.dart';

class MailboxView extends GetView<MailboxController> {
  const MailboxView({super.key});

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
          '우편함',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.invitations.isEmpty) {
          return const Center(
            child: Text(
              '받은 초대장이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.invitations.length,
          itemBuilder: (context, index) {
            final invitation = controller.invitations[index];
            return Card(
              color: const Color(0xFFD9D9D9),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${invitation['villageName']} 초대',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '보낸 사람: ${invitation['senderEmail']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () =>
                              controller.rejectInvitation(invitation['id']),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            '거레',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => controller.acceptInvitation(
                            invitation['id'],
                            invitation['villageId'],
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFC4ECF6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            '수락',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
