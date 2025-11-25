import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ★ 추가된 import

class ChatScreen extends StatefulWidget {
  final String chatRoomId; 

  const ChatScreen({super.key, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  
  // ------------------------------------------------------------------
  // ★[수정] 하드코딩된 'user1' 대신 실제 로그인 사용자 UID 사용
  // ------------------------------------------------------------------
  // (주의: 로그인 후에 이 화면에 접근해야 null 오류가 발생하지 않습니다.)
  final String myId = FirebaseAuth.instance.currentUser!.uid; 
  // 현재 로그인된 사용자의 닉네임이 있다면, 이 부분도 동적으로 가져오는 것이 좋습니다.
  final String myNickname = FirebaseAuth.instance.currentUser!.displayName ?? '나'; 

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    String msg = _controller.text;
    _controller.clear();

    await FirebaseFirestore.instance.collection('chat_rooms').doc(widget.chatRoomId).collection('messages').add({
      'text': msg, 
      'senderId': myId, // 실제 UID 사용
      'nickname': myNickname, // 실제 닉네임 (없으면 '나' 사용)
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('chat_rooms').doc(widget.chatRoomId).update({
      'lastMessage': msg, 'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("대화방", style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1.0), child: Container(color: const Color(0xFFD9D9D9), height: 1.0)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chat_rooms').doc(widget.chatRoomId).collection('messages').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, padding: const EdgeInsets.all(16), itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final bool isMe = data['senderId'] == myId;
                    return _Bubble(message: data['text'] ?? '', isMe: isMe, nickname: data['nickname'] ?? '익명');
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(28)),
            child: const Text("폭죽을 터트리겠습니까?", style: TextStyle(fontSize: 12)),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF595959))), color: Colors.white),
              child: Row(
                children: [
                  const Icon(Icons.add_box_outlined, color: Colors.grey), const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 46, padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(28)),
                      child: TextField(
                        controller: _controller, decoration: const InputDecoration(border: InputBorder.none, hintText: '메시지 입력'),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String message; final bool isMe; final String nickname;
  const _Bubble({required this.message, required this.isMe, required this.nickname});

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 60),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: const Color(0xFFC4ECF6), borderRadius: BorderRadius.circular(20)), child: Text(message, style: const TextStyle(fontSize: 16))))]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 60),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)), const SizedBox(width: 8),
          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: const Color(0xFFE7E7E7), borderRadius: BorderRadius.circular(20)), child: Text(message, style: const TextStyle(fontSize: 16)))]))
        ]),
      );
    }
  }
}