import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/invitation_service.dart';
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
  final InvitationService _invitationService = InvitationService();
  final VillageRoleService _roleService = VillageRoleService();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _description = '';
  String? _invitationCode;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;
  bool _isEditingDescription = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _loadVillageData();
    _checkPermission();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final role = await _roleService.getUserRole(widget.villageId, user.uid);
    setState(() {
      _hasPermission = role?.hasPermission(VillagePermission.manageVillageSettings) ?? false;
    });
  }

  Future<void> _loadVillageData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 마을 정보 로드
      final villageDoc = await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .get();

      if (villageDoc.exists) {
        setState(() {
          _description = villageDoc.data()?['description'] ?? '';
          _descriptionController.text = _description;
        });
      }

      // 주민 목록 로드
      final membersSnapshot = await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('members')
          .get();

      List<Map<String, dynamic>> loadedMembers = [];
      for (var doc in membersSnapshot.docs) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .get();

        if (userData.exists) {
          loadedMembers.add({
            'uid': doc.id,
            'name': userData.data()?['displayName'] ?? userData.data()?['email']?.split('@')[0] ?? '이름 없음',
            'role': doc.data()['role'] ?? 'member',
          });
        }
      }

      setState(() {
        _members = loadedMembers;
        _isLoading = false;
      });
    } catch (e) {
      print('마을 데이터 로드 에러: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateInvitationCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final code = await _invitationService.createInvitation(
        villageId: widget.villageId,
        createdBy: user.uid,
        expiresIn: const Duration(days: 7),
      );

      setState(() {
        _invitationCode = code;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('초대 코드가 생성되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대 코드 생성 실패: $e')),
        );
      }
    }
  }

  void _copyInvitationLink() {
    if (_invitationCode != null) {
      final link = _invitationService.getInvitationLink(_invitationCode!);
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('링크가 복사되었습니다')),
      );
    } else {
      _generateInvitationCode();
    }
  }

  Future<void> _updateDescription() async {
    if (!_hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('마을 설정을 수정할 권한이 없습니다')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .update({
        'description': _descriptionController.text.trim(),
      });

      setState(() {
        _description = _descriptionController.text.trim();
        _isEditingDescription = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('마을 설명이 수정되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('수정 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                width: 393,
                constraints: const BoxConstraints(minHeight: 852),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    // 뒤로가기 버튼
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

                    // 마을 관리 제목
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

                    // 마을 설명 라벨
                    const Positioned(
                      left: 35,
                      top: 171,
                      child: Text(
                        '마을 설명',
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

                    // 수정 버튼
                    if (_hasPermission)
                      Positioned(
                        left: 317,
                        top: 177,
                        child: GestureDetector(
                          onTap: () {
                            if (_isEditingDescription) {
                              _updateDescription();
                            } else {
                              setState(() {
                                _isEditingDescription = true;
                              });
                            }
                          },
                          child: Container(
                            width: 31,
                            height: 40,
                            decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                            child: Center(
                              child: Text(
                                _isEditingDescription ? '저장' : '수정',
                                style: const TextStyle(
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

                    // 마을 설명 박스
                    Positioned(
                      left: 35,
                      top: 223,
                      child: Container(
                        width: 321,
                        height: 90,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isEditingDescription
                            ? Padding(
                                padding: const EdgeInsets.all(12),
                                child: TextField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.54,
                                    letterSpacing: 0.13,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '마을 설명을 입력하세요',
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  _description.isEmpty
                                      ? '마을 설명이 없습니다'
                                      : _description,
                                  style: TextStyle(
                                    color: _description.isEmpty
                                        ? Colors.black54
                                        : Colors.black,
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.54,
                                    letterSpacing: 0.13,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // 초대장 보내기 라벨
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
                          height: 2.35,
                          letterSpacing: 0.17,
                        ),
                      ),
                    ),

                    // 초대 링크
                    Positioned(
                      left: 36,
                      top: 374,
                      child: Container(
                        width: 259,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _invitationCode != null
                                ? _invitationService.getInvitationLink(_invitationCode!)
                                : '초대 코드를 생성하려면 링크복사를 클릭하세요',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.17,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    // 링크복사 버튼
                    Positioned(
                      left: 309,
                      top: 373,
                      child: GestureDetector(
                        onTap: _copyInvitationLink,
                        child: Container(
                          width: 63,
                          height: 35,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '링크복사',
                              style: TextStyle(
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

                    // 주민 목록 라벨
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
                          height: 2.35,
                          letterSpacing: 0.17,
                        ),
                      ),
                    ),

                    // 주민 목록 박스
                    Positioned(
                      left: 30,
                      top: 594,
                      child: Container(
                        width: 339,
                        constraints: const BoxConstraints(
                          minHeight: 275,
                        ),
                        decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                        child: _members.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  '주민이 없습니다',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _members.map((member) {
                                    String roleText = '';
                                    if (member['role'] == 'creator') {
                                      roleText = ' (생성자)';
                                    } else if (member['role'] == 'admin') {
                                      roleText = ' (관리자)';
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        '${member['name']}$roleText',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                          letterSpacing: 0.17,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
