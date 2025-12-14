import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/village_role_service.dart';
import '../../../models/village_member.dart';
import 'package:get/get.dart';
import '../controllers/village_settings_controller.dart';

class VillageSettingsView extends GetView<VillageSettingsController> {
  const VillageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return VillageSettingsScreen(
      villageId: controller.villageId,
      villageName: controller.villageName,
    );
  }
}

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
  bool _isEditingDescription = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(
    text: 'OO이가 관리하는 예쁘고 평화로운 마을입니다.\n저희 마을에서 욕은 안돼요~~',
  );
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
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveDescription() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .update({'description': _descriptionController.text});

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('마을 설명이 저장되었습니다')));
      }

      setState(() {
        _isEditingDescription = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    }
  }

  void _sendInvitation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이메일을 입력해주세요')));
      return;
    }

    // 이메일 형식 검증
    if (!email.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('올바른 이메일 형식을 입력해주세요')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$email로 초대장을 보냈습니다')));
      }

      _emailController.clear();
      setState(() {
        _showEmailInput = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('초대장 전송 실패: $e')));
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
        body: Center(child: Text('접근 권한이 없습니다')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        ),
        leadingWidth: 60,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 마을 정보 섹션
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '마을 정보',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isEditingDescription)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '마을 설명',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isEditingDescription = true;
                                });
                              },
                              child: Text(
                                '수정',
                                style: GoogleFonts.gowunDodum(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_isEditingDescription)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '마을 설명',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _saveDescription,
                                  child: Text(
                                    '저장',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEditingDescription = false;
                                    });
                                  },
                                  child: Text(
                                    '취소',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _isEditingDescription
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF4DDBFF),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: _descriptionController,
                                  minLines: 1,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF4DDBFF),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _descriptionController.text,
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                // 초대장 섹션
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '초대장 보내기',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_showEmailInput)
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            top: 10,
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF4DDBFF),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'design/4N6oqrDpi0nSrF8ct0',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showEmailInput = true;
                                  });
                                },
                                child: Text(
                                  '초대하기',
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_showEmailInput)
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF4DDBFF),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '이메일 입력',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 0,
                                      ),
                                    ),
                                    style: GoogleFonts.gowunDodum(fontSize: 14),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: GestureDetector(
                                  onTap: _sendInvitation,
                                  child: Text(
                                    '보내기',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // 주민 목록 섹션
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '주민 목록',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 40),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF4DDBFF),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '김갑동\n이을서\n박병남\n최정북\n정무기',
                      style: GoogleFonts.gowunDodum(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
