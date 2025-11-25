import 'package:flutter/material.dart';
import 'village_view_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final List<String> villages = ['마을1', '마을2', '마을3'];
  late PageController _pageController;
  int _currentIndex = 1; // Start with middle village (마을2)

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
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
                _MenuButton(label: '메뉴', onTap: () {}),
              ],
            ),
          ),

          // Expanded center area with village cards carousel
          Expanded(
            child: Center(
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
                        title: villages[index],
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
                    // Handle "내 마을로 가기" tap
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