import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../community/board_screen.dart';
import 'creator_home_screen.dart';
import '../community/calendar_screen.dart';
import '../community/chat_screen.dart';
import '../user/resident_profile_screen.dart';
import 'village_settings_screen.dart';
import '../../services/village_role_service.dart';
import '../../models/village_member.dart';

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
      setState(() {
        _resolvedVillageId = widget.villageId;
      });
      print('villageId 있음: $_resolvedVillageId');
      await _loadUserRole();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // villageId가 없으면 villageName으로 검색
    try {
      print('villageName으로 검색: ${widget.villageName}');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('villages')
          .where('name', isEqualTo: widget.villageName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _resolvedVillageId = querySnapshot.docs.first.id;
        });
        print('villageName으로 찾은 ID: $_resolvedVillageId');
        await _loadUserRole();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('마을 ID 조회 오류: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserRole() async {
    if (_resolvedVillageId == null) return;
    
    try {
      final role = await _roleService.getCurrentUserRole(_resolvedVillageId!);
      setState(() {
        _currentUserRole = role;
      });
      print('사용자 권한: ${role?.roleDisplayName ?? "없음"}');
    } catch (e) {
      print('권한 로드 오류: $e');
    }
  }

  void _openCategory(BuildContext context, String category) {
    if (category == '주민집') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResidentProfileScreen(villageName: widget.villageName),
        ),
      );
    } else if (category == '게시판') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BoardScreen(villageName: widget.villageName),
        ),
      );
    } else if (category == '마을 생성자 집') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CreatorHomeScreen(villageName: widget.villageName),
        ),
      );
    } else if (category == '캘린더') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CalendarScreen(
            villageName: widget.villageName,
            villageId: _resolvedVillageId,
          ),
        ),
      );
    } else if (category == '채팅') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(villageName: widget.villageName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$category 페이지로 이동')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('VillageViewScreen 빌드 - _resolvedVillageId: $_resolvedVillageId, villageName: ${widget.villageName}');
    
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 파일명 표시 (테스트용)
            Container(
              color: Colors.yellow.withOpacity(0.3),
              padding: const EdgeInsets.all(4),
              child: const Text(
                'village_view_screen.dart',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Top bar with back and settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 63,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          '뒤로가기',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.villageName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  // Settings button
                  GestureDetector(
                    onTap: () {
                      print('설정 버튼 클릭 - _resolvedVillageId: $_resolvedVillageId, villageName: ${widget.villageName}');
                      
                      // 생성자만 설정 접근 가능
                      if (_currentUserRole?.isCreator != true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('마을 생성자만 설정을 변경할 수 있습니다')),
                        );
                        return;
                      }
                      
                      if (_resolvedVillageId != null && _resolvedVillageId!.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => VillageSettingsScreen(
                              villageId: _resolvedVillageId!,
                              villageName: widget.villageName,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('마을 정보를 불러올 수 없습니다 (villageId: $_resolvedVillageId)')),
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 47,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          '⚙️',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Village grid layout
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 21),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    // Row 1
                    _VillageCell(
                      label: '주민집',
                      onTap: () => _openCategory(context, '주민집'),
                    ),
                    _VillageCell(
                      label: '마을 생성자 집',
                      fontSize: 18,
                      onTap: () => _openCategory(context, '마을 생성자 집'),
                    ),
                    _VillageCell(
                      label: '',
                      onTap: () {},
                    ),
                    // Row 2
                    _VillageCell(
                      label: '채팅',
                      onTap: () => _openCategory(context, '채팅'),
                    ),
                    _VillageCell(
                      label: '게시판',
                      onTap: () => _openCategory(context, '게시판'),
                    ),
                    _VillageCell(
                      label: '캘린더',
                      onTap: () => _openCategory(context, '캘린더'),
                    ),
                    // Row 3 (additional cells for layout)
                    _VillageCell(
                      label: '',
                      onTap: () {},
                    ),
                    _VillageCell(
                      label: '',
                      onTap: () {},
                    ),
                    _VillageCell(
                      label: '',
                      onTap: () {},
                    ),
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

  const _VillageCell({
    required this.label,
    required this.onTap,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: label.isNotEmpty ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
