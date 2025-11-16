import 'package:flutter/material.dart';
import 'board_screen.dart';
import 'creator_home_screen.dart';
import 'calendar_screen.dart';
import 'chat_screen.dart';
import 'resident_profile_screen.dart';

class VillageViewScreen extends StatelessWidget {
  final String villageName;

  const VillageViewScreen({
    super.key,
    required this.villageName,
  });

  void _openCategory(BuildContext context, String category) {
    if (category == '주민집') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResidentProfileScreen(villageName: villageName),
        ),
      );
    } else if (category == '게시판') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BoardScreen(villageName: villageName),
        ),
      );
    } else if (category == '마을 생성자 집') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CreatorHomeScreen(villageName: villageName),
        ),
      );
    } else if (category == '캘린더') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CalendarScreen(villageName: villageName),
        ),
      );
    } else if (category == '채팅') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(villageName: villageName),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                    villageName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  // Settings button
                  Container(
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
