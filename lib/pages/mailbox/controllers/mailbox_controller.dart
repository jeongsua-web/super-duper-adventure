import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MailboxController extends GetxController {
  final RxList<Map<String, dynamic>> invitations = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadInvitations();
  }

  Future<void> loadInvitations() async {
    isLoading.value = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        isLoading.value = false;
        return;
      }

      // 현재 사용자 이메일로 받은 초대장 조회
      final invitationsSnapshot = await FirebaseFirestore.instance
          .collection('invitations')
          .where('recipientEmail', isEqualTo: user.email)
          .where('status', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> loadedInvitations = [];
      for (var doc in invitationsSnapshot.docs) {
        final data = doc.data();
        
        // 마을 정보 가져오기
        final villageDoc = await FirebaseFirestore.instance
            .collection('villages')
            .doc(data['villageId'])
            .get();

        if (villageDoc.exists) {
          loadedInvitations.add({
            'id': doc.id,
            'villageId': data['villageId'],
            'villageName': villageDoc.data()?['name'] ?? '이름 없음',
            'senderEmail': data['senderEmail'],
            'createdAt': data['createdAt'],
          });
        }
      }

      invitations.value = loadedInvitations;
      isLoading.value = false;
    } catch (e) {
      print('초대장 로드 에러: $e');
      isLoading.value = false;
    }
  }

  Future<void> acceptInvitation(String invitationId, String villageId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 마을 멤버로 추가
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .collection('members')
          .doc(user.uid)
          .set({
        'role': 'member',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      // 사용자의 마을 목록에 추가
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'villages': FieldValue.arrayUnion([villageId]),
      });

      // 초대장 상태 업데이트
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitationId)
          .update({
        'status': 'accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        '성공',
        '초대를 수락했습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // 마을이 추가되었음을 알리고 화면 닫기
      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        '실패',
        '초대 수락 실패: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rejectInvitation(String invitationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitationId)
          .update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        '성공',
        '초대를 거절했습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      loadInvitations(); // 목록 새로고침
    } catch (e) {
      Get.snackbar(
        '실패',
        '초대 거절 실패: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void goBack() {
    Get.back();
  }
}
