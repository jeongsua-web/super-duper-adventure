import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  Stream<QuerySnapshot> get chatRoomsStream {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        // orderBy는 Firestore 복합 인덱스 필요 - 임시로 주석 처리
        // .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  Future<void> createChatRoom() async {
    const String tempRecipientId = 'temp_recipient_id';

    final newRoom = await _firestore.collection('chat_rooms').add({
      'roomName': '새로운 대화방',
      'lastMessage': '대화를 시작해보세요!',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'participants': [currentUserId, tempRecipientId],
    });

    Get.toNamed('/chat', arguments: {
      'chatRoomId': newRoom.id,
      'villageName': '새로운 대화방',
    });
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    String amPm = date.hour < 12 ? '오전' : '오후';
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '$amPm $hour:${date.minute.toString().padLeft(2, '0')}';
  }

  void goToChatRoom(String chatRoomId) {
    Get.toNamed('/chat', arguments: {'chatRoomId': chatRoomId});
  }
}
