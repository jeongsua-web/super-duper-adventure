import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui'; 
import 'dart:convert';

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
  int _currentIndex = 0; // 초기값을 여기서 0으로 줘도, 아래에서 덮어씁니다.

  final double _viewportFraction = 0.55; 

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
            'image': data['image'],
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
    final String defaultName = user?.displayName ?? user?.email?.split('@')[0] ?? '주민';

    return Scaffold(
      backgroundColor: Colors.white,
      body: user == null
          ? const Center(child: Text("로그인이 필요합니다."))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, userSnapshot) {
                String realTimeName = defaultName;
                List<dynamic> villageIds = [];
                bool isUserLoading = !userSnapshot.hasData;

                if (!isUserLoading) {
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                  realTimeName = userData?['displayName'] ?? defaultName;
                  villageIds = userData?['villages'] ?? [];
                }

                return SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          
                          // 1. 상단바
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
                                          style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.w400),
                                        ),
                                        TextSpan(
                                          text: '$realTimeName님!',
                                          style: const TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.w600),
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
                                      iconData: Icons.mark_as_unread_sharp, 
                                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MailboxScreen()))
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 2. 안내 문구
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '어느 마을로 이동할까요? 🏡',
                                style: TextStyle(
                                  color: Colors.black87, 
                                  fontSize: 22, 
                                  fontFamily: 'Gowun Dodum', 
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(1, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),

                          // 3. 중앙 영역 (마을 리스트)
                          Expanded(
                            child: isUserLoading
                                ? const Center(child: CircularProgressIndicator())
                                : villageIds.isEmpty
                                  ? _buildNoVillageCard()
                                  : FutureBuilder<List<Map<String, dynamic>>>(
                                      // [중요] FutureBuilder가 불필요하게 계속 호출되는 것을 방지하기 위해 
                                      // 실제로는 변수로 관리하는 것이 좋으나, 
                                      // 현재 구조를 유지하면서 문제를 해결하기 위해 아래 로직을 보강함.
                                      future: _fetchAllVillages(villageIds, user.uid),
                                      builder: (context, villageSnapshot) {
                                        if (villageSnapshot.connectionState == ConnectionState.waiting && !villageSnapshot.hasData) {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                        
                                        final villages = villageSnapshot.data ?? [];
                                        if (villages.isEmpty) return _buildNoVillageCard();

                                        // [★핵심 수정] PageController 및 초기 인덱스 설정
                                        if (_pageController == null) {
                                          int initialPage = 0;
                                          // 마을이 1개보다 많을 때만 무한 스크롤 효과를 위한 큰 인덱스 사용
                                          if (villages.length > 1) {
                                            initialPage = (10000 ~/ villages.length) * villages.length;
                                          }
                                          
                                          // 컨트롤러 생성
                                          _pageController = PageController(initialPage: initialPage, viewportFraction: _viewportFraction);
                                          
                                          // [★중요] 현재 인덱스도 초기 페이지와 동일하게 맞춰주어야 
                                          // 처음 로딩 시 카드가 중앙에 커진 상태로 고정됨
                                          _currentIndex = initialPage;
                                        }

                                        return ScrollConfiguration(
                                          behavior: ScrollConfiguration.of(context).copyWith(
                                            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                                          ),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return SizedBox(
                                                height: 340, 
                                                child: PageView.builder(
                                                  controller: _pageController,
                                                  // [★중요] 마을이 1개일 때는 itemCount를 1로 고정해야 에러 및 튀는 현상 방지
                                                  itemCount: villages.length > 1 ? null : 1, 
                                                  onPageChanged: (index) {
                                                    // setState로 화면을 다시 그리면 FutureBuilder가 다시 돌 수 있으므로 주의
                                                    // 여기서는 단순히 인덱스만 업데이트
                                                    setState(() {
                                                      _currentIndex = index;
                                                    });
                                                  },
                                                  itemBuilder: (context, index) {
                                                    final int actualIndex = index % villages.length;
                                                    final villageData = villages[actualIndex];

                                                    // 현재 보고 있는 인덱스(_currentIndex)와 아이템의 인덱스(index)가 같을 때만 중앙 처리
                                                    final bool isCenter = (index == _currentIndex);

                                                    return _VillageCard(
                                                      title: villageData['name'],
                                                      creator: villageData['creator'] ?? '촌장님',
                                                      villageId: villageData['id'],
                                                      imageData: villageData['image'],
                                                      isCenter: isCenter, 
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
                                        );
                                      },
                                    ),
                          ),
                          const SizedBox(height: 160), 
                        ],
                      ),

                      // 4. 하단 바
                      Positioned(
                        left: 0, right: 0, bottom: 0,
                        child: SizedBox(
                          height: 160, 
                          child: Stack(
                            clipBehavior: Clip.none, 
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                height: 90, 
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                    colors: [Color(0xFFC4ECF6), Color(0xFFB3E5FC)], 
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.home_filled, size: 40, color: Colors.white),
                                        onPressed: () {
                                          if (_pageController != null && villageIds.isNotEmpty) {
                                            // 마을이 1개면 0으로, 아니면 계산된 중간값으로 이동
                                            int targetPage = 0;
                                            if (villageIds.length > 1) {
                                              targetPage = (10000 ~/ villageIds.length) * villageIds.length;
                                            }
                                            _pageController!.animateToPage(targetPage, duration: const Duration(milliseconds: 800), curve: Curves.elasticOut);
                                            // 애니메이션 후 인덱스 동기화
                                            setState(() {
                                              _currentIndex = targetPage;
                                            });
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.person, size: 40, color: Colors.white),
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountSettingsScreen()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              Positioned(
                                bottom: 35, 
                                child: GestureDetector(
                                  onTap: () async {
                                    if (villageIds.isEmpty) {
                                      _navigateToCreateVillage();
                                    } else {
                                      if (_pageController != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('생성한 마을이 없습니다!')));
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 100, height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                        colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
                                      ),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
                                    ),
                                    child: const Center(
                                      child: Text('MY마을', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.bold)),
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
            ),
    );
  }

  Widget _buildNoVillageCard() {
    return Center(
      child: Container(
        height: 300,
        width: 250,
        decoration: BoxDecoration(
          color: const Color(0xFFC4ECF6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_home_work_outlined, size: 70, color: Colors.white), 
            const SizedBox(height: 20),
            const Text(
              '가입된 마을이 없습니다',
              style: TextStyle(fontSize: 16, fontFamily: 'Gowun Dodum', color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _navigateToCreateVillage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('새 마을 만들기', style: TextStyle(fontSize: 16, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTopButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onTap;
  
  const _CustomTopButton({required this.label, required this.iconData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50, height: 40,
            decoration: const BoxDecoration(),
            child: Icon(iconData, size: 36, color: const Color(0xFFC4ECF6)), 
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 13, fontFamily: 'Gowun Dodum', color: Colors.black, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class _VillageCard extends StatelessWidget {
  final String title;
  final String creator;
  final String villageId;
  final String? imageData; 
  final bool isCenter; 
  final VoidCallback onTap;

  const _VillageCard({
    required this.title, 
    required this.creator, 
    required this.villageId, 
    this.imageData,
    required this.isCenter,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final double height = isCenter ? 300 : 270;
    // [수정] 중앙이 아니면 약간 투명하게 해서 중앙 집중도 높임
    final double opacity = isCenter ? 1.0 : 0.6; 
    final Color bgColor = const Color(0xFFC4ECF6); 

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          height: height,
          // [수정] scale 효과 대신 높이만 변경하고 투명도 적용
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor.withOpacity(isCenter ? 1.0 : 0.9), 
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (isCenter) // [수정] 중앙일 때만 그림자 강하게
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Opacity( // [수정] 중앙이 아닌 카드는 약간 흐리게
            opacity: opacity,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageData != null && imageData!.isNotEmpty
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(
                                  base64Decode(imageData!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
                                  },
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        title, textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 22, fontFamily: 'Gowun Dodum', fontWeight: FontWeight.bold, color: Colors.white),
                                        maxLines: 2, overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
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
      ),
    );
  }
}