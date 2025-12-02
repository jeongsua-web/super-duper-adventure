import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// [기존 import 유지]
import '../community/board_screen.dart';
import 'creator_home_screen.dart';
import '../community/calendar_screen.dart';
import '../user/resident_profile_screen.dart';
import 'village_settings_screen.dart';
import '../../services/village_role_service.dart';
import '../../models/village_member.dart';

// [수정] ChatListScreen은 지우고, ChatScreen만 남겨둡니다.
import '../community/chat_screen.dart'; 

class VillageViewScreen extends StatefulWidget {
  final String villageName;
  final String? villageId;

  const VillageViewScreen({
    super.key,
    required this.villageName,
    this.villageId,
  });

  @override
  State<VillageViewScreen> createState() => _VillageViewScreenState();
}

class _VillageViewScreenState extends State<VillageViewScreen> {
  String? _resolvedVillageId;
  bool _isLoading = true;
  VillageMember? _currentUserRole;
  final VillageRoleService _roleService = VillageRoleService();

  @override
  void initState() {
    super.initState();
    _resolveVillageId();
  }

  Future<void> _resolveVillageId() async {
    if (widget.villageId != null && widget.villageId!.isNotEmpty) {
      setState(() => _resolvedVillageId = widget.villageId);
      await _loadUserRole();
      setState(() => _isLoading = false);
      return;
    }
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('villages')
          .where('name', isEqualTo: widget.villageName)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() => _resolvedVillageId = querySnapshot.docs.first.id);
        await _loadUserRole();
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserRole() async {
    if (_resolvedVillageId == null) return;
    try {
      final role = await _roleService.getCurrentUserRole(_resolvedVillageId!);
      setState(() => _currentUserRole = role);
    } catch (e) {
      print(e);
    }
  }

  // [버튼 클릭 시 이동 로직]
  void _openCategory(BuildContext context, String category) {
    if (category == '주민집') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResidentProfileScreen(villageName: widget.villageName)));
    } else if (category == '게시판') {
      if (_resolvedVillageId != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => BoardScreen(
          villageName: widget.villageName,
          villageId: _resolvedVillageId!,
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('마을 ID를 찾을 수 없습니다.')));
      }
    } else if (category == '마을 생성자 집') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreatorHomeScreen(villageName: widget.villageName)));
    } else if (category == '캘린더') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CalendarScreen(villageName: widget.villageName, villageId: _resolvedVillageId)));
    } 
    
    // -----------------------------------------------------------
    // [★수정] '채팅' 버튼 클릭 시 마을 이름을 함께 전달
    // -----------------------------------------------------------
    else if (category == '채팅') {
      if (_resolvedVillageId != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatRoomId: _resolvedVillageId!, 
            // ▼▼▼ 이 부분이 추가되었습니다! ▼▼▼
            villageName: widget.villageName, 
          ), 
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('마을 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.'))
        );
      }
    } 
    
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$category 페이지로 이동')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 63, height: 38,
                      decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(4)),
                      child: const Center(child: Text('뒤로가기', style: TextStyle(fontSize: 14))),
                    ),
                  ),
                  Text(widget.villageName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  GestureDetector(
                    onTap: () {
                        if (_currentUserRole?.isCreator != true) {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('마을 생성자만 접근 가능')));
                         return;
                        }
                        if (_resolvedVillageId != null) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => VillageSettingsScreen(villageId: _resolvedVillageId!, villageName: widget.villageName)));
                        }
                    },
                    child: Container(
                      width: 60, height: 47,
                      decoration: BoxDecoration(color: const Color(0xFFD9D9D9), border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4)),
                      child: const Center(child: Text('⚙️', style: TextStyle(fontSize: 32))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 그리드 버튼들
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 21),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(8)),
                child: GridView.count(
                  crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.0,
                  children: [
                    _VillageCell(label: '주민집', onTap: () => _openCategory(context, '주민집')),
                    _VillageCell(label: '마을 생성자 집', fontSize: 16, onTap: () => _openCategory(context, '마을 생성자 집')),
                    _VillageCell(label: '', onTap: () {}),
                    
                    // 채팅 버튼
                    _VillageCell(label: '채팅', onTap: () => _openCategory(context, '채팅')),
                    
                    _VillageCell(label: '게시판', onTap: () => _openCategory(context, '게시판')),
                    _VillageCell(label: '캘린더', onTap: () => _openCategory(context, '캘린더')),
                    _VillageCell(label: '', onTap: () {}),
                    _VillageCell(label: '', onTap: () {}),
                    _VillageCell(label: '', onTap: () {}),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _VillageCell extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double fontSize;
  const _VillageCell({required this.label, required this.onTap, this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: label.isNotEmpty ? onTap : null,
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFD9D9D9), border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(4)),
        child: Center(child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize, color: Colors.black))),
      ),
    );
  }
}