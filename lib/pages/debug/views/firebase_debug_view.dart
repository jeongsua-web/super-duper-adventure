import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/firebase_debug_controller.dart';

class FirebaseDebugView extends GetView<FirebaseDebugController> {
  const FirebaseDebugView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase 연결 상태'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...controller.firebaseStatus.entries.map((entry) {
              final isConnected = entry.value is bool && entry.value == true;
              final isError = entry.key.toLowerCase().contains('error');

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (isConnected)
                            const Icon(Icons.check_circle,
                                color: Colors.green)
                          else if (isError)
                            const Icon(Icons.error, color: Colors.red)
                          else
                            const Icon(Icons.info, color: Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.value.toString(),
                        style: TextStyle(
                          color: isError ? Colors.red : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.refresh,
              child: const Text('새로고침'),
            ),
          ],
        );
      }),
    );
  }
}
