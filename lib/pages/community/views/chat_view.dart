import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'dart:convert';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  Path _drawHeart(Size size) {
    final path = Path();
    path.moveTo(0.5 * size.width, size.height * 0.35);
    path.cubicTo(0.2 * size.width, size.height * 0.1, -0.25 * size.width,
        size.height * 0.6, 0.5 * size.width, size.height);
    path.moveTo(0.5 * size.width, size.height * 0.35);
    path.cubicTo(0.8 * size.width, size.height * 0.1, 1.25 * size.width,
        size.height * 0.6, 0.5 * size.width, size.height);
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF4CDBFF);
    const Color subBlue = Color(0xFFC4ECF6);
    const Color inputBgBlue = Color(0xFFEAFBFF);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        scrolledUnderElevation: 0,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.villageName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 1.00),
            end: Alignment(0.50, 0.00),
            colors: [mainBlue, subBlue],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: controller.messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text("오류"));
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "첫 메시지를 남겨보세요!",
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      }

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          return _Bubble(
                            message: data['text'],
                            imageBase64: data['imageBase64'],
                            isMe: data['senderId'] == controller.myId,
                            nickname: data['nickname'] ?? '익명',
                            timestamp: data['createdAt'] as Timestamp?,
                            formatTime: controller.formatTime,
                          );
                        },
                      );
                    },
                  ),
                ),

                Obx(() {
                  if (controller.detectedKeyword.value != null) {
                    return GestureDetector(
                      onTap: controller.triggerEffect,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.detectedKeyword.value == 'party'
                                  ? '🎉'
                                  : '🩷',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.detectedKeyword.value == 'party'
                                  ? '축하 폭죽 터트리기'
                                  : '하트 날리기',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: subBlue, width: 1.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: mainBlue,
                            size: 28,
                          ),
                          onPressed: controller.showAttachmentSheet,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: inputBgBlue,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: subBlue, width: 1),
                            ),
                            child: TextField(
                              controller: controller.messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '메시지를 입력하세요',
                                hintStyle: TextStyle(color: Colors.black38),
                                contentPadding: EdgeInsets.only(bottom: 8),
                              ),
                              onSubmitted: (text) =>
                                  controller.sendMessage(text: text),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.send, color: mainBlue),
                          onPressed: () => controller.sendMessage(
                            text: controller.messageController.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: controller.partyController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow
                ],
                gravity: 0.3,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: controller.loveController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                createParticlePath: _drawHeart,
                colors: const [
                  Color(0xFFFFC0CB),
                  Color(0xFFFF69B4),
                  Color(0xFFFF1493),
                  Colors.redAccent
                ],
                gravity: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String? message;
  final String? imageBase64;
  final bool isMe;
  final String nickname;
  final Timestamp? timestamp;
  final String Function(Timestamp?) formatTime;

  const _Bubble({
    this.message,
    this.imageBase64,
    required this.isMe,
    required this.nickname,
    this.timestamp,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = formatTime(timestamp);

    Widget bubbleContent;
    if (imageBase64 != null) {
      try {
        bubbleContent = Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(imageBase64!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
        );
      } catch (e) {
        bubbleContent = const Text("이미지 로딩 실패");
      }
    } else {
      bubbleContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFC4ECF6) : Colors.white,
          border: Border.all(
            width: 1.5,
            color: isMe ? Colors.white : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(18),
            topLeft:
                isMe ? const Radius.circular(18) : const Radius.circular(0),
          ),
        ),
        child: Text(
          message ?? '',
          style: const TextStyle(fontSize: 15),
        ),
      );
    }

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeString,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
            const SizedBox(width: 4),
            Flexible(child: bubbleContent),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color(0xFFC4ECF6),
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: bubbleContent),
                      const SizedBox(width: 4),
                      Text(
                        timeString,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
