import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart'; // [중요] 아래 3번 파일 import

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  void _createChatRoom(BuildContext context) async {
    final newRoom = await FirebaseFirestore.instance.collection('chat_rooms').add({
      'roomName': '새로운 대화방', 
      'lastMessage': '대화를 시작해보세요!',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'participants': ['user1', 'user2'], 
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
        stream: FirebaseFirestore.instance.collection('chat_rooms').orderBy('lastMessageTime', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () => _createChatRoom(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD9D9D9), foregroundColor: Colors.black),
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