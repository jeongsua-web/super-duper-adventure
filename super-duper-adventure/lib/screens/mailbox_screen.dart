import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MailboxScreen extends StatefulWidget {
  const MailboxScreen({super.key});

  @override
  State<MailboxScreen> createState() => _MailboxScreenState();
}

class _MailboxScreenState extends State<MailboxScreen> {
  List<Map<String, dynamic>> _invitations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
        });
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

      setState(() {
        _invitations = loadedInvitations;
        _isLoading = false;
      });
    } catch (e) {
      print('초대장 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptInvitation(String invitationId, String villageId) async {
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('초대를 수락했습니다')),
        );
        // 마을이 추가되었음을 알리고 화면 닫기
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대 수락 실패: $e')),
        );
      }
    }
  }

  Future<void> _rejectInvitation(String invitationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invitations')
          .doc(invitationId)
          .update({
        'status': 'rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('초대를 거절했습니다')),
        );
        _loadInvitations(); // 목록 새로고침
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대 거절 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '우편함',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _invitations.isEmpty
              ? const Center(
                  child: Text(
                    '받은 초대장이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontFamily: 'Gowun Dodum',
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _invitations.length,
                  itemBuilder: (context, index) {
                    final invitation = _invitations[index];
                    return Card(
                      color: const Color(0xFFD9D9D9),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${invitation['villageName']} 초대',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '보낸 사람: ${invitation['senderEmail']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _rejectInvitation(invitation['id']),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey[400],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    '거절',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => _acceptInvitation(
                                    invitation['id'],
                                    invitation['villageId'],
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFC4ECF6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text(
                                    '수락',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
