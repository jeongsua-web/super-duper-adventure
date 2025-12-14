import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            onCancel?.call();
          },
          child: Text(
            cancelText ?? '취소',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            onConfirm?.call();
          },
          child: Text(
            confirmText ?? '확인',
            style: TextStyle(
              color: confirmColor ?? const Color(0xFF4DDBFF),
            ),
          ),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) {
    return Get.dialog<bool>(
      ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        onConfirm: () => Get.back(result: true),
        onCancel: () => Get.back(result: false),
      ),
    );
  }
}
