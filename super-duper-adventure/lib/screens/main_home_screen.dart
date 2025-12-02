import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'village/village_view_screen.dart';
import 'village/village_create_screen.dart';
import 'mailbox_screen.dart';
import 'settings/account_settings_screen.dart';

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
      print('===== 마을 로드 시작 =====');
      print('현재 사용자: ${user?.uid}');
      print('이메일: ${user?.email}');
      
      if (user == null) {
        print('오류: 로그인하지 않았습니다');
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
      
      print('사용자 문서 존재: ${userDoc.exists}');
      if (userDoc.exists) {
        print('사용자 데이터: ${userDoc.data()}');
        print('Villages 필드: ${userDoc.data()?['villages']}');
      }
      
      if (userDoc.exists && userDoc.data()?['villages'] != null) {
        final villagesData = userDoc.data()!['villages'];
        print('마을 데이터 타입: ${villagesData.runtimeType}');
        final villageIds = (villagesData is List) 
            ? villagesData.map((e) => e.toString()).toList()
            : <String>[];
        
        print('마을 ID 목록: $villageIds');
        
        // Fetch village details
        List<Map<String, dynamic>> loadedVillages = [];
        for (String villageId in villageIds) {
          final villageDoc = await FirebaseFirestore.instance
              .collection('villages')
              .doc(villageId)
              .get();
          
          print('마을 $villageId 존재: ${villageDoc.exists}');
          
          if (villageDoc.exists && villageDoc.data() != null) {
            final villageData = {
              'id': villageId,
              'name': villageDoc.data()!['name'] ?? '이름 없음',
              'description': villageDoc.data()!['description'] ?? '',
            };
            print('로드된 마을: $villageData');
            loadedVillages.add(villageData);
          }
        }

        print('총 로드된 마을 수: ${loadedVillages.length}');
        setState(() {
          villages = loadedVillages;
          _isLoading = false;
        });
      } else {
        print('오류: villages 배열이 없거나 null입니다');
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top menu bar with two buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MenuButton(label: '메뉴', onTap: () {}),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MailboxScreen(),
                            ),
                          );
                          if (result == true) {
                            _loadUserVillages();
                          }
                        },
                        child: const Icon(
                          Icons.mail_outline,
                          size: 32,
                          color: Color(0xFFC4ECF6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Expanded center area with village cards carousel
                Expanded(
                  child: Center(
                    child: villages.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                '아직 가입한 마을이\n없습니다',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Gowun Dodum',
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _navigateToCreateVillage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC4ECF6),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  '새 마을 만들기',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
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
                                final villageData = villages[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: _VillageCard(
                                    title: villageData['name'],
                                    villageId: villageData['id'],
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
                      if (villages.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VillageViewScreen(
                                  villageName: villages[_currentIndex]['name'],
                                  villageId: villages[_currentIndex]['id'],
                                ),
                              ),
                            );
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
                            const Text(
                              '마을 목록',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.01,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AccountSettingsScreen(),
                                  ),
                                );
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
  final String villageId;
  final bool isCenter;

  const _VillageCard({
    required this.title,
    required this.villageId,
    required this.isCenter,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCenter
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VillageViewScreen(
                    villageName: title,
                    villageId: villageId,
                  ),
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