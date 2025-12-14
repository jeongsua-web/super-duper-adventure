import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../village/village_view_screen.dart';
import '../main_home_screen.dart';
import 'quiz_sol_screen.dart';
import 'quiz_view_screen.dart';
import 'quiz_create_screen.dart';
import 'search_screen.dart';

class QuizScreen extends StatelessWidget {
  final String villageName;
  final String villageId;

  const QuizScreen({
    super.key,
    required this.villageName,
    required this.villageId,
  });

  String _formatDate(Timestamp timestamp) {
    return DateFormat('yyyy.M.d').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// ================= 상단 헤더 =================
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MainHomeScreen())),
                        child: Stack(
                          children: [
                            Text(
                              '마이마을',
                              style: GoogleFonts.bagelFatOne(
                                fontSize: 24,
                                foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.black,
                              ),
                            ),
                            Text('마이마을', style: GoogleFonts.bagelFatOne(fontSize: 24, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VillageViewScreen(villageName: villageName))),
                        child: Text(villageName, style: GoogleFonts.gowunDodum(fontSize: 20)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen(villageName: villageName))),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ================= 퀴즈 리스트 영역 =================
          Expanded(
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .where('villageName', isEqualTo: villageName)
                    // ★★★ [중요] 정렬 코드 삭제함 (이게 인덱스 오류 원인) ★★★
                    // .orderBy('createdAt', descending: true) 
                    .snapshots(),
                builder: (context, snapshot) {
                  // 1. 에러 확인
                  if (snapshot.hasError) {
                    return Center(child: Text("에러: ${snapshot.error}")); 
                  }
                  // 2. 로딩
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  // 3. 데이터 없음
                  if (docs.isEmpty) {
                     return Center(
                       child: Text("데이터 없음\n(마을: $villageName)", style: GoogleFonts.gowunDodum()),
                     );
                  }

                  final now = DateTime.now();
                  List<QueryDocumentSnapshot> todayQuizzes = [];
                  List<QueryDocumentSnapshot> pastQuizzes = [];

                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    
                    // createdAt이 없으면 현재 시간으로 처리 (앱 죽는 거 방지)
                    Timestamp ts = data['createdAt'] is Timestamp 
                        ? data['createdAt'] 
                        : Timestamp.now();
                        
                    final createdAt = ts.toDate();
                    final diff = now.difference(createdAt).inHours;

                    if (diff < 24) {
                      todayQuizzes.add(doc);
                    } else {
                      pastQuizzes.add(doc);
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    children: [
                      Text('진행중인 퀴즈', style: GoogleFonts.gowunDodum(fontSize: 24)),
                      const SizedBox(height: 20),
                      if (todayQuizzes.isEmpty)
                        Container(
                          width: double.infinity, height: 120,
                          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(23)),
                          alignment: Alignment.center,
                          child: Text("진행중인 퀴즈가 없어요", style: GoogleFonts.gowunDodum(color: Colors.grey)),
                        )
                      else
                        ...todayQuizzes.map((doc) => _buildTodayQuizCard(context, doc)),

                      const SizedBox(height: 40),

                      Text('종료된 퀴즈', style: GoogleFonts.gowunDodum(fontSize: 24)),
                      const SizedBox(height: 20),
                      if (pastQuizzes.isEmpty)
                        const Padding(padding: EdgeInsets.all(8.0), child: Text("지난 퀴즈가 없습니다."))
                      else
                        ...pastQuizzes.map((doc) => _buildPastQuizCard(context, doc)),
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizCreateScreen(villageName: villageName))),
        backgroundColor: const Color(0xFF4CDBFF),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildTodayQuizCard(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizSolScreen(villageName: villageName, quizData: data, docId: doc.id)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFC4ECF6), borderRadius: BorderRadius.circular(23)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['title'] ?? '제목 없음', style: GoogleFonts.gowunDodum(fontSize: 24)),
            const SizedBox(height: 10),
            Text(data['description'] ?? '내용 없음', style: GoogleFonts.gowunDodum(fontSize: 18), maxLines: 2),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, height: 50,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
              alignment: Alignment.center,
              child: Text('퀴즈 풀기', style: GoogleFonts.gowunDodum(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastQuizCard(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // null 체크 강화
    final timestamp = data['createdAt'] is Timestamp ? data['createdAt'] : Timestamp.now();

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizViewScreen(villageName: villageName, quizData: data)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: const Color(0xFFC4ECF6), borderRadius: BorderRadius.circular(23)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(data['title'] ?? '제목 없음', overflow: TextOverflow.ellipsis, style: GoogleFonts.gowunDodum(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Text(_formatDate(timestamp), style: GoogleFonts.gowunDodum(color: const Color(0xFF595959), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}