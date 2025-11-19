import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/village_role_service.dart';
import '../../models/village_member.dart';

class VillageSettingsScreen extends StatefulWidget {
  final String villageId;
  final String villageName;

  const VillageSettingsScreen({
    super.key,
    required this.villageId,
    required this.villageName,
  });

  @override
  State<VillageSettingsScreen> createState() => _VillageSettingsScreenState();
}

class _VillageSettingsScreenState extends State<VillageSettingsScreen> {
  bool _showEmailInput = false;
  final TextEditingController _emailController = TextEditingController();
  VillageMember? _currentUserRole;
  bool _isLoadingRole = true;
  final VillageRoleService _roleService = VillageRoleService();

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      final role = await _roleService.getCurrentUserRole(widget.villageId);
      setState(() {
        _currentUserRole = role;
        _isLoadingRole = false;
      });
      
      if (role?.isCreator != true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('마을 생성자만 설정을 변경할 수 있습니다')),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('권한 로드 오류: $e');
      setState(() {
        _isLoadingRole = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendInvitation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일을 입력해주세요')),
      );
      return;
    }

    // 이메일 형식 검증
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 이메일 형식을 입력해주세요')),
      );
      return;
    }
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Firestore에 초대장 저장
      await FirebaseFirestore.instance.collection('invitations').add({
        'villageId': widget.villageId,
        'villageName': widget.villageName,
        'recipientEmail': email,
        'senderEmail': user.email,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$email로 초대장을 보냈습니다')),
        );
      }
      
      _emailController.clear();
      setState(() {
        _showEmailInput = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대장 전송 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingRole) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentUserRole?.isCreator != true) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('접근 권한이 없습니다'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 파일명 표시 (테스트용)
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              color: Colors.yellow.withOpacity(0.3),
              padding: const EdgeInsets.all(4),
              child: const Text(
                'village_settings_screen.dart',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            left: 21,
            top: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 63,
                height: 38,
                decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                child: const Center(
                  child: Text(
                    '뒤로가기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      letterSpacing: 0.16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 24,
            top: 129,
            child: Text(
              '마을 관리',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.95,
                letterSpacing: 0.19,
              ),
            ),
          ),
          const Positioned(
            left: 35,
            top: 171,
            child: SizedBox(
              width: 100,
              height: 41,
              child: Text(
                '마을 설명',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.17,
                ),
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 223,
            child: Container(
              width: 321,
              height: 90,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: const Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'OO이가 관리하는 예쁘고 평화로운 마을입니다.\n저희 마을에서 욕은 안돼요~~',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.54,
                  letterSpacing: 0.13,
                ),
              ),
            ),
          ),
          Positioned(
            left: 317,
            top: 177,
            child: GestureDetector(
              onTap: () {
                // 수정 기능
              },
              child: Container(
                width: 31,
                height: 40,
                decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                child: const Center(
                  child: Text(
                    '수정',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.13,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 35,
            top: 334,
            child: Text(
              '초대장 보내기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.17,
              ),
            ),
          ),
          // 이메일 입력창 또는 링크 표시
          if (!_showEmailInput)
            Positioned(
              left: 36,
              top: 374,
              child: Container(
                width: 259,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: ShapeDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'design/4N6oqrDpi0nSrF8ct0',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.17,
                    ),
                  ),
                ),
              ),
            ),
          // 이메일 입력창
          if (_showEmailInput)
            Positioned(
              left: 36,
              top: 374,
              child: Container(
                width: 259,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '이메일 입력',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          // 보내기/링크복사 버튼
          Positioned(
            left: 309,
            top: 373,
            child: GestureDetector(
              onTap: () {
                if (_showEmailInput) {
                  _sendInvitation();
                } else {
                  setState(() {
                    _showEmailInput = true;
                  });
                }
              },
              child: Container(
                width: 63,
                height: 35,
                decoration: ShapeDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    _showEmailInput ? '보내기' : '링크복사',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 35,
            top: 553,
            child: Text(
              '주민 목록',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.17,
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 594,
            child: Container(
              width: 339,
              height: 275,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '김갑동\n이을서\n박병남\n최정북\n정무기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 2.35,
                    letterSpacing: 0.17,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
