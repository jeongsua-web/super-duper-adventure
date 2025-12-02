import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

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

  String? _detectedKeyword; // 현재 감지된 키워드 (party or love)
  Timer? _buttonTimer; // 버튼 유지 시간을 제어할 타이머

  final String myId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
  final String myNickname = FirebaseAuth.instance.currentUser?.displayName ?? '익명';

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

  // [수정] 버튼을 누르면 효과 실행 + 버튼 즉시 제거
  void _triggerEffect() {
    if (_detectedKeyword == 'party') {
      _partyController.play();
    } else if (_detectedKeyword == 'love') {
      _loveController.play();
    }
    
    // 타이머 취소 및 버튼 즉시 숨김
    _buttonTimer?.cancel();
    setState(() {
      _detectedKeyword = null;
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    String msg = _controller.text;
    
    // 메시지 전송 시 키워드 감지
    String? newKeyword;
    if (msg.contains('축하')) {
      newKeyword = 'party';
    } else if (msg.contains('사랑')) {
      newKeyword = 'love';
    }

    _controller.clear();

    if (newKeyword != null) {
      _buttonTimer?.cancel(); // 기존 타이머 취소
      
      setState(() {
        _detectedKeyword = newKeyword;
      });

      // [수정] 4초 뒤에 버튼을 숨김
      _buttonTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _detectedKeyword = null;
          });
        }
      });
    } else {
      setState(() {
        _detectedKeyword = null;
      });
    }

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add({
      'text': msg,
      'senderId': myId,
      'nickname': myNickname,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .set({
      'lastMessage': msg,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'roomName': widget.villageName,
      'participants': FieldValue.arrayUnion([myId]),
    }, SetOptions(merge: true));
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
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          widget.villageName,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
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
                      if (snapshot.hasError) return Center(child: Text("오류"));
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(
                            child: Text("첫 메시지를 남겨보세요!", style: TextStyle(color: Colors.black54)));
                      }

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          return _Bubble(
                            message: data['text'] ?? '',
                            isMe: data['senderId'] == myId,
                            nickname: data['nickname'] ?? '익명',
                            timestamp: data['createdAt'] as Timestamp?,
                          );
                        },
                      );
                    },
                  ),
                ),

                // [버튼 표시 영역] 전송 후 키워드가 감지되면 나타남
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
                            _detectedKeyword == 'party' ? '🎉' : '🩷',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _detectedKeyword == 'party' ? '축하 폭죽 터트리기' : '하트 날리기',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 입력창 영역
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: subBlue, width: 1.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline, color: mainBlue, size: 28),
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
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.send, color: mainBlue),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // 축하 폭죽 (위 -> 아래)
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

            // 하트 효과 (아래 -> 위)
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _loveController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                createParticlePath: _drawHeart, 
                colors: const [
                  Color(0xFFFFC0CB), 
                  Color(0xFFFF69B4), 
                  Color(0xFFFF1493), 
                  Colors.redAccent,
                ],
                gravity: 0.05, // 천천히 떨어지게 설정
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
  final String message;
  final bool isMe;
  final String nickname;
  final Timestamp? timestamp;

  const _Bubble({
    required this.message,
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

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(timeString, style: const TextStyle(fontSize: 10, color: Colors.black54)),
            const SizedBox(width: 4),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFC4ECF6),
                  border: Border.all(width: 1.5, color: Colors.white),
                  borderRadius: BorderRadius.circular(18).copyWith(bottomRight: const Radius.circular(0)),
                ),
                child: Text(message, style: const TextStyle(fontSize: 15)),
              ),
            ),
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
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18).copyWith(topLeft: const Radius.circular(0)),
                          ),
                          child: Text(message, style: const TextStyle(fontSize: 15)),
                        ),
                      ),
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