import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'village_view_screen.dart';
import 'village_create_screen.dart';
import 'invitation_input_screen.dart';
import 'invitation_create_screen.dart';
import 'village_settings_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  List<Map<String, dynamic>> villages = [];
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadUserVillages();
  }

  Future<void> _loadUserVillages() async {
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

      // Get user's villages
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data()?['villages'] != null) {
        final villagesData = userDoc.data()!['villages'];
        final villageIds = (villagesData is List) 
            ? villagesData.map((e) => e.toString()).toList()
            : <String>[];
        
        // Fetch village details
        List<Map<String, dynamic>> loadedVillages = [];
        for (String villageId in villageIds) {
          final villageDoc = await FirebaseFirestore.instance
              .collection('villages')
              .doc(villageId)
              .get();
          
          if (villageDoc.exists && villageDoc.data() != null) {
            loadedVillages.add({
              'id': villageId,
              'name': villageDoc.data()!['name'] ?? '이름 없음',
              'description': villageDoc.data()!['description'] ?? '',
            });
          }
        }

        setState(() {
          villages = loadedVillages;
          _isLoading = false;
        });
      } else {
        setState(() {
          villages = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('마을 로드 에러: $e');
      setState(() {
        villages = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToCreateVillage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VillageCreateScreen()),
    );

    if (result == true) {
      // Reload villages after creating a new one
      _loadUserVillages();
    }
  }

  Future<void> _navigateToInvitationInput() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const InvitationInputScreen()),
    );

    if (result == true) {
      // Reload villages after joining a new one
      _loadUserVillages();
    }
  }

  void _showVillageMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text(
                  '새 마을 만들기',
                  style: TextStyle(fontFamily: 'Gowun Dodum'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCreateVillage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text(
                  '초대 코드로 입주하기',
                  style: TextStyle(fontFamily: 'Gowun Dodum'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToInvitationInput();
                },
              ),
              if (villages.isNotEmpty) ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.card_giftcard),
                  title: const Text(
                    '초대 코드 생성',
                    style: TextStyle(fontFamily: 'Gowun Dodum'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (_currentIndex < villages.length) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => InvitationCreateScreen(
                            villageId: villages[_currentIndex]['id'],
                            villageName: villages[_currentIndex]['name'],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top menu bar with two buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MenuButton(label: '메뉴', onTap: () {}),
                _MenuButton(
                  label: '설정',
                  onTap: () {
                    if (villages.isNotEmpty && _currentIndex < villages.length) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VillageSettingsScreen(
                            villageId: villages[_currentIndex]['id'],
                            villageName: villages[_currentIndex]['name'],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // Expanded center area with village cards carousel or empty state
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : villages.isEmpty
                    ? _buildEmptyState()
                    : Center(
                        child: SizedBox(
                          height: 350,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemCount: villages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: _VillageCard(
                                  title: villages[index]['name'],
                                  isCenter: index == _currentIndex,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),

          // Bottom navigation bar with circle button
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                // Circle button (Go to my village)
                GestureDetector(
                  onTap: () {
                    if (villages.isNotEmpty && _currentIndex < villages.length) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VillageViewScreen(
                            villageName: villages[_currentIndex]['name'],
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 101,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFBCBCBC),
                    ),
                    child: const Center(
                      child: Text(
                        '내 마을로\n가기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Inter',
                          letterSpacing: 0.01,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tab labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _showVillageMenu,
                        child: const Text(
                          '마을 목록',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.01,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // Handle "내 계정" tap
                        },
                        child: const Text(
                          '내 계정',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            '아직 가입한 마을이 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Gowun Dodum',
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _navigateToCreateVillage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC4ECF6),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text(
              '새 마을 만들기',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gowun Dodum',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _navigateToInvitationInput,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFFC4ECF6)),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '초대 코드로 입주하기',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gowun Dodum',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 63,
        height: 58,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.01,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _VillageCard extends StatelessWidget {
  final String title;
  final bool isCenter;

  const _VillageCard({
    required this.title,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCenter
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VillageViewScreen(villageName: title),
                ),
              );
            }
          : null,
      child: Transform.scale(
        scale: isCenter ? 1.0 : 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: isCenter ? const Color(0xFFD9D9D9) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Village icon/image placeholder
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_city,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  letterSpacing: 0.01,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}