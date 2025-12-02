import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../village/village_view_screen.dart';

class QuizCreateScreen extends StatefulWidget {
  final String villageName;

  const QuizCreateScreen({super.key, required this.villageName});

  @override
  State<QuizCreateScreen> createState() => _QuizCreateScreenState();
}

class _QuizCreateScreenState extends State<QuizCreateScreen> {
  String _selectedType = '단답형';
  List<String> _options = ['담안 작성', '담안 작성', '담안 작성', '담안 작성'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 헤더
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VillageViewScreen(
                                villageName: widget.villageName,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          widget.villageName,
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Icon(Icons.edit, color: Colors.white, size: 28),
                    ],
                  ),
                ),
              ),
            ),

            // 콘텐츠 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 입력
                  Text(
                    '퀴즈 제목을 입력하세요.',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 구분선
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 40),

                  // 중앙 빈 공간 (이미지나 콘텐츠 영역)
                  SizedBox(height: 150),

                  // 구분선
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 20),

                  // 문제 유형 선택
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = '단답형';
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _selectedType == '단답형'
                                          ? const Color(0xFF4CDBFF)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '단답형',
                                    style: GoogleFonts.gowunDodum(
                                      color: _selectedType == '단답형'
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = '객관형';
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _selectedType == '객관형'
                                          ? const Color(0xFF4CDBFF)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '○ 단답형 ○ 객관형',
                                    style: GoogleFonts.gowunDodum(
                                      color: _selectedType == '객관형'
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
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
                  const SizedBox(height: 20),

                  // 선택지 리스트
                  ..._options.asMap().entries.map((entry) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '○',
                                style: GoogleFonts.gowunDodum(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _options[entry.key],
                                  style: GoogleFonts.gowunDodum(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            // 하단 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.photo_camera,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.note_add,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.text_fields,
                      size: 32,
                      color: Colors.grey,
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
