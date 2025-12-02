import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui'; 

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
  PageController? _pageController;
  int _currentIndex = 0;

  // [★수정] 가로 폭을 더 줄여서(0.65 -> 0.60) 카드를 더 날씬하게 만듦
  final double _viewportFraction = 0.60; 

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _navigateToCreateVillage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const VillageCreateScreen()),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAllVillages(List<dynamic> allVillageIds, String myUid) async {
    List<Map<String, dynamic>> allVillages = [];
    int chunkSize = 10;
    
    for (var i = 0; i < allVillageIds.length; i += chunkSize) {
      List<dynamic> chunk = allVillageIds.sublist(
        i, 
        i + chunkSize > allVillageIds.length ? allVillageIds.length : i + chunkSize
      );

      if (chunk.isNotEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('villages')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          String creatorName = '알 수 없음';
          String creatorId = data['createdBy'] ?? '';

          try {
            if (creatorId.isNotEmpty) {
              final userDoc = await FirebaseFirestore.instance.collection('users').doc(creatorId).get();
              creatorName = userDoc.data()?['displayName'] ?? '익명';
            }
          } catch (_) {}

          allVillages.add({
            'id': doc.id,
            'name': data['name'] ?? '이름 없음',
            'description': data['description'] ?? '',
            'creator': creatorName,
            'creatorId': creatorId,
          });
        }
      }
    }

    allVillages.sort((a, b) {
      bool isMyVillageA = a['creatorId'] == myUid;
      bool isMyVillageB = b['creatorId'] == myUid;
      if (isMyVillageA && !isMyVillageB) return -1;
      if (!isMyVillageA && isMyVillageB) return 1; 
      return 0; 
    });

    return allVillages;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // [★수정] '주민' 대신 실제 닉네임 가져오기 (없으면 이메일 앞부분이라도)
    final String userName = user?.displayName ?? user?.email?.split('@')[0] ?? '주민';

    return Scaffold(
      backgroundColor: Colors.white,
      body: user == null
          ? const Center(child: Text("로그인이 필요합니다."))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());

                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                
                // [★추가] 실시간으로 업데이트된 닉네임 반영
                final String realTimeName = userData?['displayName'] ?? userName;
                
                List<dynamic> villageIds = userData?['villages'] ?? [];

                if (villageIds.isEmpty) return _buildEmptyState(realTimeName);

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchAllVillages(villageIds, user.uid),
                  builder: (context, villageSnapshot) {
                    if (villageSnapshot.connectionState == ConnectionState.waiting && !villageSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    final villages = villageSnapshot.data ?? [];
                    if (villages.isEmpty) return _buildEmptyState(realTimeName);

                    if (_pageController == null) {
                      int initialPage = (10000 ~/ villages.length) * villages.length;
                      _pageController = PageController(initialPage: initialPage, viewportFraction: _viewportFraction);
                    }

                    return SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              
                              // ---------------- [1. 상단바] ----------------
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: '어서오세요 ',
                                              style: TextStyle(
                                                color: Colors.black, 
                                                fontSize: 17, 
                                                fontFamily: 'Gowun Dodum', 
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '$realTimeName님!', // [★수정] 닉네임 부분
                                              style: const TextStyle(
                                                color: Colors.black, 
                                                fontSize: 17, 
                                                fontFamily: 'Gowun Dodum', 
                                                fontWeight: FontWeight.w600, // 이름만 살짝 강조
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _CustomTopButton(
                                          label: '메뉴',
                                          iconData: Icons.menu,
                                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountSettingsScreen()))
                                        ),
                                        _CustomTopButton(
                                          label: '우편함', 
                                          iconData: Icons.mark_as_unread_sharp, // 우편함 느낌 아이콘
                                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MailboxScreen()))
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              // 2. 안내 문구
                              const Text(
                                '어느 마을로 이동할까요?',
                                style: TextStyle(
                                  color: Colors.black, 
                                  fontSize: 20, 
                                  fontFamily: 'Gowun Dodum', 
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              
                              const SizedBox(height: 20),

                              // 3. 슬라이드 (PageView)
                              Expanded(
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                    },
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SizedBox(
                                        height: 380, 
                                        child: PageView.builder(
                                          controller: _pageController,
                                          itemCount: villages.length > 1 ? null : 1, 
                                          onPageChanged: (index) {
                                            setState(() {
                                              _currentIndex = index;
                                            });
                                          },
                                          itemBuilder: (context, index) {
                                            final int actualIndex = index % villages.length;
                                            final villageData = villages[actualIndex];

                                            return _VillageCard(
                                              title: villageData['name'],
                                              creator: villageData['creator'] ?? '촌장님',
                                              villageId: villageData['id'],
                                              isCenter: index == _currentIndex, 
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => VillageViewScreen(
                                                      villageName: villageData['name'],
                                                      villageId: villageData['id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ),
                              const SizedBox(height: 110), 
                            ],
                          ),

                          // ---------------- [4. 하단 바] ----------------
                          Positioned(
                            left: 0, right: 0, bottom: 0,
                            child: SizedBox(
                              height: 130,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: 80, 
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD9D9D9), 
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 35, 
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_pageController != null && villages.isNotEmpty) {
                                          int currentPage = _pageController!.page!.round();
                                          int targetPage = (currentPage ~/ villages.length) * villages.length;
                                          _pageController!.animateToPage(
                                            targetPage, 
                                            duration: const Duration(milliseconds: 600), 
                                            curve: Curves.easeInOutCubic,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 90, height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                            colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
                                          ),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'MY마을',
                                            style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(String userName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Text(
            '어서오세요 $userName님!',
            style: const TextStyle(fontSize: 18, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 40),
          Icon(Icons.home_work_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('가입된 마을이 없습니다.', style: TextStyle(fontSize: 16, fontFamily: 'Gowun Dodum', color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToCreateVillage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC4ECF6),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('새 마을 만들기', style: TextStyle(fontFamily: 'Gowun Dodum')),
          ),
        ],
      ),
    );
  }
}

// ---------------- [위젯 분리] ----------------

// [★수정] 아이콘 디자인 변경 (테두리 없이 색상만 적용)
class _CustomTopButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  
  const _CustomTopButton({
    required this.label, 
    required this.iconData,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // 아이콘 (테두리 없음, 하늘색)
          Container(
            width: 50, height: 40,
            decoration: BoxDecoration(
              // 피그마처럼 은은한 하늘색 배경이 필요하면 color를 0xFFC4ECF6로, 아니면 아이콘 색만 변경
              // 여기서는 피그마 이미지처럼 아이콘 자체를 하늘색으로 표현
            ),
            child: Icon(iconData, size: 36, color: const Color(0xFFC4ECF6)), 
          ),
          const SizedBox(height: 2),
          Text(
            label, 
            style: const TextStyle(
              fontSize: 13, 
              fontFamily: 'Gowun Dodum', 
              color: Colors.black,
              fontWeight: FontWeight.w400,
            )
          ),
        ],
      ),
    );
  }
}

class _VillageCard extends StatelessWidget {
  final String title;
  final String creator;
  final String villageId;
  final bool isCenter; 
  final VoidCallback onTap;

  const _VillageCard({
    required this.title, 
    required this.creator, 
    required this.villageId, 
    required this.isCenter,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    // 세로 길이는 유지하고, 가로 폭은 viewportFraction(0.6)에 의해 좁아보임
    final double height = isCenter ? 380 : 340;
    final Color bgColor = const Color(0xFFC4ECF6); 

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: height,
          // 마진을 줄여서 카드 사이 간격 조절
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor, 
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4, 
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_city_rounded, size: 70, color: Color(0xFFBCBCBC)),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            title, textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.bold, color: Colors.black),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  alignment: Alignment.center,
                  child: Text('$creator 님의 마을', style: const TextStyle(fontSize: 15, fontFamily: 'Gowun Dodum', color: Colors.black54)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}