import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ★ 추가된 import
import 'chat_screen.dart'; // [중요] 아래 3번 파일 import

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  void _createChatRoom(BuildContext context) async {
    // ------------------------------------------------------------------
    // ★[수정] 현재 사용자 ID를 가져와 사용합니다.
    // ------------------------------------------------------------------
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // 임시 상대방 ID를 사용하여 1:1 방을 만듭니다. 실제 구현에서는 여기서 상대방을 선택해야 합니다.
    final String tempRecipientId = 'temp_recipient_id'; 

    final newRoom = await FirebaseFirestore.instance.collection('chat_rooms').add({
      'roomName': '새로운 대화방', 
      'lastMessage': '대화를 시작해보세요!',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      // ------------------------------------------------------------------
      // ★[수정] participants에 실제 UID와 임시 상대방 ID를 넣습니다.
      // ------------------------------------------------------------------
      'participants': [currentUserId, tempRecipientId], 
    });
    
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: newRoom.id)),
      );
    }
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    String amPm = date.hour < 12 ? '오전' : '오후';
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '$amPm $hour:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------
    // ★[추가] 현재 사용자 ID를 가져와 필터링에 사용합니다.
    // (주의: 로그인이 되어 있어야 합니다.)
    // ------------------------------------------------------------------
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('채팅 목록', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: () => _createChatRoom(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat_rooms')
            // ------------------------------------------------------------------
            // ★[수정] .where()를 사용하여 현재 사용자가 참여한 방만 가져옵니다.
            // ------------------------------------------------------------------
            .where('participants', arrayContains: currentUserId)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          
          // ... (나머지 로직은 그대로 유지)
          // ...
          
          if (docs.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () => _createChatRoom(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC4ECF6), foregroundColor: Colors.black),
                child: const Text("채팅방 만들기"),
              ),
            );
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: docs[index].id)));
                },
                leading: Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(data['roomName'] ?? '채팅방', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(data['lastMessage'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                trailing: Text(_formatTime(data['lastMessageTime']), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              );
            },
          );
        },
      ),
    );
  }
}