import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/village_role_service.dart';


class VillageInvitationScreen extends StatefulWidget {
  final String invitationCode;
  final String? villageName;
  final String? invitationMessage;

  const VillageInvitationScreen({
    super.key,
    required this.invitationCode,
    this.villageName,
    this.invitationMessage,
  });

  @override
  State<VillageInvitationScreen> createState() => _VillageInvitationScreenState();
}

class _VillageInvitationScreenState extends State<VillageInvitationScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _villageData;
  String? _creatorName;

  @override
  void initState() {
    super.initState();
    _loadInvitationData();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _loadInvitationData() async {
    try {
      // 초대 코드로 마을 정보 가져오기
      final invitationDoc = await FirebaseFirestore.instance
          .collection('invitations')
          .doc(widget.invitationCode)
          .get();

      if (invitationDoc.exists) {
        final villageId = invitationDoc.data()!['villageId'];
        final villageDoc = await FirebaseFirestore.instance
            .collection('villages')
            .doc(villageId)
            .get();

        if (villageDoc.exists) {
          final createdBy = villageDoc.data()!['createdBy'];
          final creatorDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(createdBy)
              .get();

          setState(() {
            _villageData = villageDoc.data();
            _villageData!['id'] = villageId;
            _creatorName = creatorDoc.data()?['displayName'] ?? '마을 생성자';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('초대장 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptInvitation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다')),
      );
      return;
    }

    if (_villageData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효하지 않은 초대장입니다')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final villageId = _villageData!['id'];
      final roleService = VillageRoleService();

      // 마을 멤버로 추가
      await roleService.addMember(villageId, user.uid);

      // 사용자의 마을 목록에 추가
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'villages': FieldValue.arrayUnion([villageId]),
        'displayName': _nicknameController.text.trim().isEmpty
            ? null
            : _nicknameController.text.trim(),
      }, SetOptions(merge: true));

      // 마을 멤버 수 증가
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(villageId)
          .update({
        'memberCount': FieldValue.increment(1),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_villageData!['name']} 마을에 입주했습니다!')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('입주 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? '손님';

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: 393,
              height: 852,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  // 닫기 버튼
                  Positioned(
                    left: 310,
                    top: 14,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 63,
                        height: 58,
                        decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                        child: const Center(
                          child: Text(
                            '닫기',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                              letterSpacing: 0.12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 초대장 제목
                  const Positioned(
                    left: 176,
                    top: 261,
                    child: Text(
                      '초대장',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),

                  // 초대 메시지
                  Positioned(
                    left: 96,
                    top: 287,
                    child: SizedBox(
                      width: 205,
                      height: 173,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: '\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.20,
                                letterSpacing: 0.15,
                              ),
                            ),
                            TextSpan(
                              text: '\n$userName님께\n당신을 ${_villageData?['name'] ?? 'OO마을'}에 초대합니다.\n\n',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: 0.12,
                              ),
                            ),
                            TextSpan(
                              text: _villageData?['description'] ?? '(관리자가 자유롭게 꾸밀 수 있는 초대장)',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                                letterSpacing: 0.12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 서명 라벨
                  const Positioned(
                    left: 252,
                    top: 489,
                    child: Text(
                      '서명',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ),

                  // 생성자 이름 표시
                  Positioned(
                    left: 227,
                    top: 507,
                    child: Container(
                      width: 72,
                      height: 54,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _creatorName ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.80,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 입주 확인 메시지
                  const Positioned(
                    left: 113,
                    top: 575,
                    child: Text(
                      '입주하시겠습니까?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ),

                  // 닉네임 입력 필드
                  Positioned(
                    left: 96,
                    top: 600,
                    child: SizedBox(
                      width: 205,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '닉네임 (선택)',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 40,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE7E7E7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: TextField(
                              controller: _nicknameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                hintText: '닉네임 입력',
                                hintStyle: TextStyle(fontSize: 10),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 수락 버튼
                  Positioned(
                    left: 96,
                    top: 680,
                    child: GestureDetector(
                      onTap: _isLoading ? null : _acceptInvitation,
                      child: Container(
                        width: 205,
                        height: 45,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFC4ECF6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  '입주하기',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  // 거절 버튼
                  Positioned(
                    left: 96,
                    top: 735,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 205,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '거절하기',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
