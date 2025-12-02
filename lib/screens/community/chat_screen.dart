import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:async';
import 'dart:convert'; // Base64 변환용
// [삭제] import 'dart:io'; <-- 웹에서는 이 라이브러리를 쓰면 안 됩니다!

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String villageName;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    this.villageName = '마을 채팅방',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  
  late ConfettiController _partyController;
  late ConfettiController _loveController;

  String? _detectedKeyword; 
  Timer? _buttonTimer; 

  final String myId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
  final String myNickname = FirebaseAuth.instance.currentUser?.displayName ?? '익명';
  final ImagePicker _picker = ImagePicker(); 

  @override
  void initState() {
    super.initState();
    _partyController = ConfettiController(duration: const Duration(seconds: 3));
    _loveController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _partyController.dispose();
    _loveController.dispose();
    _buttonTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _triggerEffect() {
    if (_detectedKeyword == 'party') {
      _partyController.play();
    } else if (_detectedKeyword == 'love') {
      _loveController.play();
    }
    _buttonTimer?.cancel();
    setState(() {
      _detectedKeyword = null;
    });
  }

  // 메시지 전송
  void _sendMessage({String? text, String? imageBase64}) async {
    if ((text == null || text.trim().isEmpty) && imageBase64 == null) return;

    String msg = text ?? (imageBase64 != null ? '사진을 보냈습니다.' : '');
    
    if (text != null) {
      _controller.clear(); 
      String? newKeyword;
      if (text.contains('축하')) {
        newKeyword = 'party';
      } else if (text.contains('사랑')) {
        newKeyword = 'love';
      }

      if (newKeyword != null) {
        _buttonTimer?.cancel();
        setState(() => _detectedKeyword = newKeyword);
        _buttonTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) setState(() => _detectedKeyword = null);
        });
      } else {
        setState(() => _detectedKeyword = null);
      }
    }

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add({
      'text': text, 
      'imageBase64': imageBase64, 
      'senderId': myId,
      'nickname': myNickname,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .set({
      'lastMessage': imageBase64 != null ? '사진' : msg, 
      'lastMessageTime': FieldValue.serverTimestamp(),
      'roomName': widget.villageName,
      'participants': FieldValue.arrayUnion([myId]),
    }, SetOptions(merge: true));
  }

  // [★수정됨] 웹/앱 모두 호환되는 이미지 처리 함수
  Future<void> _pickAndConvertImage(ImageSource source) async {
    try {
      // 1. 이미지 선택 (용량 줄이기 설정 필수)
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 20, // 화질 20%
        maxWidth: 500,    // 가로 500px 제한 (Firestore 용량 제한 때문)
        maxHeight: 500,
      );
      
      if (image == null) return;

      // [핵심 변경] File(image.path) 대신 readAsBytes() 사용!
      // 이렇게 하면 웹 브라우저에서도 문제 없이 데이터를 읽어옵니다.
      final Uint8List imageBytes = await image.readAsBytes();
      
      // Base64 문자열로 변환
      String base64String = base64Encode(imageBytes);

      // 전송
      _sendMessage(imageBase64: base64String);
      
    } catch (e) {
      print('이미지 처리 오류: $e');
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('사진 전송 중 오류가 발생했습니다.')));
      }
    }
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
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
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentOption(
                    icon: Icons.photo_library,
                    label: '앨범',
                    color: Colors.pinkAccent,
                    onTap: () {
                      Navigator.pop(context);
                      _pickAndConvertImage(ImageSource.gallery);
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.camera_alt,
                    label: '카메라',
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.pop(context);
                      _pickAndConvertImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
        shape: const Border(bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          widget.villageName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.menu, color: Colors.black), onPressed: () {}),
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
                    stream: FirebaseFirestore.instance
                        .collection('chat_rooms')
                        .doc(widget.chatRoomId)
                        .collection('messages')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const Center(child: Text("오류"));
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(child: Text("첫 메시지를 남겨보세요!", style: TextStyle(color: Colors.black54)));
                      }

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          return _Bubble(
                            message: data['text'], 
                            imageBase64: data['imageBase64'], 
                            isMe: data['senderId'] == myId,
                            nickname: data['nickname'] ?? '익명',
                            timestamp: data['createdAt'] as Timestamp?,
                          );
                        },
                      );
                    },
                  ),
                ),

                if (_detectedKeyword != null)
                  GestureDetector(
                    onTap: _triggerEffect,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_detectedKeyword == 'party' ? '🎉' : '🩷', style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            _detectedKeyword == 'party' ? '축하 폭죽 터트리기' : '하트 날리기',
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: subBlue, width: 1.5)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: mainBlue, size: 28),
                          onPressed: _showAttachmentSheet, 
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
                              controller: _controller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '메시지를 입력하세요',
                                hintStyle: TextStyle(color: Colors.black38),
                                contentPadding: EdgeInsets.only(bottom: 8),
                              ),
                              onSubmitted: (text) => _sendMessage(text: text),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.send, color: mainBlue),
                          onPressed: () => _sendMessage(text: _controller.text),
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
                confettiController: _partyController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.red, Colors.green, Colors.blue, Colors.yellow],
                gravity: 0.3,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _loveController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                createParticlePath: _drawHeart,
                colors: const [Color(0xFFFFC0CB), Color(0xFFFF69B4), Color(0xFFFF1493), Colors.redAccent],
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

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({required this.icon, required this.label, required this.color, required this.onTap});

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
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
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

  const _Bubble({
    this.message,
    this.imageBase64,
    required this.isMe,
    required this.nickname,
    this.timestamp,
  });

  String _formatTime(Timestamp? timestamp) {
    DateTime date = timestamp?.toDate() ?? DateTime.now();
    String amPm = date.hour < 12 ? '오전' : '오후';
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    String minute = date.minute.toString().padLeft(2, '0');
    return '$amPm $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final timeString = _formatTime(timestamp);

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
                return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
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
          border: Border.all(width: 1.5, color: isMe ? Colors.white : Colors.transparent),
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(18),
            topLeft: isMe ? const Radius.circular(18) : const Radius.circular(0),
          ),
        ),
        child: Text(message ?? '', style: const TextStyle(fontSize: 15)),
      );
    }

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(timeString, style: const TextStyle(fontSize: 10, color: Colors.black54)),
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
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: const Icon(Icons.person, color: Color(0xFFC4ECF6), size: 24),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: bubbleContent),
                      const SizedBox(width: 4),
                      Text(timeString, style: const TextStyle(fontSize: 10, color: Colors.black54)),
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