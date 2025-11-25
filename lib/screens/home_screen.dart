import 'package:flutter/material.dart';

import '../widgets/village_card.dart';
import 'community/board_screen.dart';
import 'community/quiz_screen.dart';
import 'community/calendar_screen.dart';
import 'user/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // ⚠️ [중요]: 실제 앱에서는 로그인된 사용자의 실제 마을 ID를 가져와서 사용해야 합니다.
  // 현재는 컴파일 오류를 해결하기 위해 임시 ID를 사용합니다.
  static const String TEMPORARY_VILLAGE_ID = 'your_resolved_village_id_here'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('우리 마을', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('오늘의 소식과 기능을 확인하세요', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _open(context, const ProfileScreen()),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Search bar
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '검색어를 입력하세요',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Horizontal village cards
              Text('주요 지역', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return const SizedBox(width: 220, child: VillageCard());
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Feature grid
              Text('바로가기', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                  children: [
                    _FeatureCard(
                      icon: Icons.forum_outlined,
                      label: '게시판',
                      // 🚨 [수정된 부분]: BoardScreen에 villageId를 추가했습니다.
                      onTap: () => _open(context, const BoardScreen(
                        villageName: '우리 마을',
                        villageId: TEMPORARY_VILLAGE_ID, // 임시 ID 사용
                      )),
                    ),
                    _FeatureCard(
                      icon: Icons.quiz_outlined,
                      label: '퀴즈',
                      onTap: () => _open(context, const QuizScreen()),
                    ),
                    _FeatureCard(
                      icon: Icons.calendar_today_outlined,
                      label: '일정',
                      // 🚨 [수정된 부분]: CalendarScreen에도 villageId를 추가해야 합니다.
                      onTap: () => _open(context, const CalendarScreen(
                        villageName: '우리 마을',
                        villageId: TEMPORARY_VILLAGE_ID, // 임시 ID 사용
                      )),
                    ),
                    _FeatureCard(
                      icon: Icons.person_outline,
                      label: '내 정보',
                      onTap: () => _open(context, const ProfileScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FeatureCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade50,
                child: Icon(icon, color: Colors.blue),
              ),
              const Spacer(),
              Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}