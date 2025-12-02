import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'village/village_create_screen.dart';
import 'mailbox_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class VillageCardData {
  final String id;
  final String name;
  final String description;

  VillageCardData({
    required this.id,
    required this.name,
    required this.description,
  });
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String userName = '사용자';
  List<VillageCardData> villages = [];
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadUserVillages();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && mounted) {
          setState(() {
            userName = userDoc.data()?['name'] ?? '사용자';
          });
        }
      }
    } catch (e) {
      print('사용자 이름 로드 실패: $e');
    }
  }

  Future<void> _loadUserVillages() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (!mounted) return;
      
      if (userDoc.exists && userDoc.data()?['villages'] != null) {
        final villagesData = userDoc.data()!['villages'];
        final villageIds = (villagesData is List) 
            ? villagesData.map((e) => e.toString()).toList()
            : <String>[];
        
        List<VillageCardData> loadedVillages = [];
        for (String villageId in villageIds) {
          final villageDoc = await FirebaseFirestore.instance
              .collection('villages')
              .doc(villageId)
              .get();
          
          if (!mounted) return;
          
          if (villageDoc.exists && villageDoc.data() != null) {
            loadedVillages.add(
              VillageCardData(
                id: villageId,
                name: villageDoc.data()!['name'] ?? '이름 없음',
                description: villageDoc.data()!['description'] ?? '',
              ),
            );
          }
        }

        if (!mounted) return;
        setState(() {
          villages = loadedVillages;
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          villages = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('마을 로드 에러: $e');
      if (!mounted) return;
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFC4ECF6),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Top section with status bar and greeting
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '9:41',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 13,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Container(
                                width: 21,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Menu and Mailbox buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/menu.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
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
                            child: Image.asset(
                              'assets/images/mailbox.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Welcome greeting
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC4ECF6), width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '어서오세요 $userName님!',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Title
                      const Text(
                        '어느 마을로 이동할까요?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                // Village carousel
                if (villages.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemCount: villages.length,
                      itemBuilder: (context, index) {
                        final village = villages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed('/village', arguments: {
                                  'villageName': village.name,
                                  'villageId': village.id,
                                });
                              },
                              child: Container(
                              decoration: ShapeDecoration(
                                color: Colors.grey[300],
                                image: const DecorationImage(
                                  image: NetworkImage("https://placehold.co/400x300"),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 3,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.black54,
                                    width: double.infinity,
                                    child: Text(
                                      village.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Gowun Dodum',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_city_outlined,
                        size: 60,
                        color: Colors.grey,
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
                        ),
                        child: const Text('새 마을 만들기'),
                      ),
                    ],
                  ),

                const SizedBox(height: 140), // Space for bottom nav
              ],
            ),
          ),

          // Bottom navigation bar with gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC4ECF6),
                    Color(0xFF4CDBFF),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/village.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                      // Center space for floating button
                      const SizedBox(width: 80),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/settings');
                        },
                        child: Image.asset(
                          'assets/images/person.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating MY마을 button
          Positioned(
            left: (MediaQuery.of(context).size.width - 101) / 2,
            bottom: 50,
            child: GestureDetector(
              onTap: villages.isNotEmpty
                  ? () {
                      Get.toNamed('/village', arguments: {
                        'villageName': villages[_currentIndex].name,
                        'villageId': villages[_currentIndex].id,
                      });
                    }
                  : null,
              child: Container(
                width: 101,
                height: 100,
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.50, -0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
                  ),
                  shape: const OvalBorder(),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 8,
                      offset: Offset(0, -6),
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'MY마을',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w600,
                      height: 1.47,
                    ),
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