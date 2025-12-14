import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  final String villageName;

  const SearchScreen({super.key, required this.villageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 그라디언트 헤더
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, 1.00),
                end: Alignment(0.50, 0.00),
                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 상단바 (시간, 배터리)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '9:41',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.signal_cellular_4_bar, size: 16),
                            const SizedBox(width: 4),
                            const Icon(Icons.wifi, size: 16),
                            const SizedBox(width: 4),
                            Container(
                              width: 24,
                              height: 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 8,
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 헤더 (X, 마을 이름)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 왼쪽: X 버튼
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        // 중앙: 마을 이름
                        Text(
                          villageName,
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // 오른쪽: 빈 공간 (균형 맞추기)
                        const SizedBox(width: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 검색 컨텐츠 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 검색창
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '검색어 입력',
                            hintStyle: GoogleFonts.gowunDodum(
                              color: const Color(0xFF676767),
                              fontSize: 16,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 최근 검색어
                  Text(
                    '최근 검색어',
                    style: GoogleFonts.gowunDodum(
                      color: const Color(0xFF676767),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 검색어 목록
                  ListView(
                    shrinkWrap: true,
                    children: [
                      _buildSearchItem('고양이'),
                      _buildSearchItem('우돌'),
                      _buildSearchItem('두발'),
                      _buildSearchItem('초록'),
                      _buildSearchItem('지수'),
                      // 전체 삭제
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '전체 삭제',
                            style: GoogleFonts.gowunDodum(
                              color: const Color(0xFF676767),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: GoogleFonts.gowunDodum(color: Colors.black, fontSize: 16),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              '삭제',
              style: GoogleFonts.gowunDodum(
                color: const Color(0xFF676767),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
