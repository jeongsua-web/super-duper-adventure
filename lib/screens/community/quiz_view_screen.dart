import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizViewScreen extends StatelessWidget {
  final String villageName;
  final Map<String, dynamic> quizData; // 이전 화면에서 넘겨받은 데이터

  const QuizViewScreen({
    super.key,
    required this.villageName,
    required this.quizData,
  });

  @override
  Widget build(BuildContext context) {
    // 데이터 안전하게 추출
    final String title = quizData['title'] ?? '제목 없음';
    final String imageUrl = quizData['imageUrl'] ?? '';
    final String answer = quizData['answer'] ?? '정답 정보 없음';
    final String description = quizData['description'] ?? '설명이 없습니다.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= 상단 헤더 =================
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        // 닫으면 이전 목록 화면으로 돌아감
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white, size: 28),
                      ),
                      Text(villageName, style: GoogleFonts.gowunDodum(fontSize: 18)),
                      const SizedBox(width: 28),
                    ],
                  ),
                ),
              ),
            ),

            // ================= 결과 내용 영역 =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.gowunDodum(fontSize: 24)),
                  const SizedBox(height: 20),

                  // 이미지 (있을 때만 표시)
                  if (imageUrl.isNotEmpty)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxHeight: 280),
                          color: Colors.grey[200],
                          child: Image.network(
                            imageUrl, 
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error_outline)),
                          ),
                        ),
                      ),
                    ),
                  
                  if (imageUrl.isNotEmpty) const SizedBox(height: 30),

                  // 설명 텍스트
                  Center(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gowunDodum(fontSize: 18, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 20),

                  Text('정답', style: GoogleFonts.gowunDodum(fontSize: 14)),
                  const SizedBox(height: 10),
                  
                  // 정답 표시 박스
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF4CDBFF), width: 1.5), // 정답 강조 테두리
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF4CDBFF), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            answer,
                            style: GoogleFonts.gowunDodum(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}