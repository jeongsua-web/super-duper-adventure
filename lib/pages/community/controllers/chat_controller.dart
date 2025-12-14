import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class ChatController extends GetxController {
  final String chatRoomId;
  final String villageName;

  ChatController({
    required this.chatRoomId,
    this.villageName = '마을 채팅방',
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController messageController = TextEditingController();
  late ConfettiController partyController;
  late ConfettiController loveController;

  final Rx<String?> detectedKeyword = Rx<String?>(null);
  Timer? buttonTimer;

  String get myId => _auth.currentUser?.uid ?? 'unknown';
  String get myNickname => _auth.currentUser?.displayName ?? '익명';

  Stream<QuerySnapshot> get messagesStream {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  void onInit() {
    super.onInit();
    partyController = ConfettiController(duration: const Duration(seconds: 3));
    loveController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void onClose() {
    partyController.dispose();
    loveController.dispose();
    buttonTimer?.cancel();
    messageController.dispose();
    super.onClose();
  }

  void triggerEffect() {
    if (detectedKeyword.value == 'party') {
      partyController.play();
    } else if (detectedKeyword.value == 'love') {
      loveController.play();
    }
    buttonTimer?.cancel();
    detectedKeyword.value = null;
  }

  Future<void> sendMessage({String? text, String? imageBase64}) async {
    if ((text == null || text.trim().isEmpty) && imageBase64 == null) return;

    String msg = text ?? (imageBase64 != null ? '사진을 보냈습니다.' : '');

    if (text != null) {
      messageController.clear();
      String? newKeyword;
      if (text.contains('축하')) {
        newKeyword = 'party';
      } else if (text.contains('사랑')) {
        newKeyword = 'love';
      }

      if (newKeyword != null) {
        buttonTimer?.cancel();
        detectedKeyword.value = newKeyword;
        buttonTimer = Timer(const Duration(seconds: 4), () {
          detectedKeyword.value = null;
        });
      } else {
        detectedKeyword.value = null;
      }
    }

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': text,
      'imageBase64': imageBase64,
      'senderId': myId,
      'nickname': myNickname,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'lastMessage': imageBase64 != null ? '사진' : msg,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'roomName': villageName,
      'participants': FieldValue.arrayUnion([myId]),
    }, SetOptions(merge: true));
  }

  Future<void> pickAndConvertImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 20,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (image == null) return;

      final Uint8List imageBytes = await image.readAsBytes();
      String base64String = base64Encode(imageBytes);

      await sendMessage(imageBase64: base64String);
    } catch (e) {
      print('이미지 처리 오류: $e');
      Get.snackbar('오류', '사진 전송 중 오류가 발생했습니다.');
    }
  }

  void showAttachmentSheet() {
    Get.bottomSheet(
      Container(
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachmentOption(
                  icon: Icons.photo_library,
                  label: '앨범',
                  color: Colors.pinkAccent,
                  onTap: () {
                    Get.back();
                    pickAndConvertImage(ImageSource.gallery);
                  },
                ),
                _AttachmentOption(
                  icon: Icons.camera_alt,
                  label: '카메라',
                  color: Colors.blueAccent,
                  onTap: () {
                    Get.back();
                    pickAndConvertImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  String formatTime(Timestamp? timestamp) {
    DateTime date = timestamp?.toDate() ?? DateTime.now();
    String amPm = date.hour < 12 ? '오전' : '오후';
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    String minute = date.minute.toString().padLeft(2, '0');
    return '$amPm $hour:$minute';
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
