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
  List<String> _options = ['', '', '', ''];
  List<TextEditingController> _optionControllers = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int? _correctAnswer; // 정답 저장 (0, 1, 2, 3 또는 null)

  @override
  void initState() {
    super.initState();
    _optionControllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showQuizTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '문제 유형 선택',
                  style: GoogleFonts.gowunDodum(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text('단답형', style: GoogleFonts.gowunDodum(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  _showAnswerInputBottomSheet('단답형');
                },
              ),
              ListTile(
                title: Text('객관형', style: GoogleFonts.gowunDodum(fontSize: 14)),
                onTap: () {
                  Navigator.pop(context);
                  _showAnswerInputBottomSheet('객관형');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showAnswerInputBottomSheet(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 70,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 탭 버튼
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  type = '단답형';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: type == '단답형'
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
                                      color: type == '단답형'
                                          ? const Color(0xFF4CDBFF)
                                          : Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  type = '객관형';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: type == '객관형'
                                          ? const Color(0xFF4CDBFF)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '객관형',
                                    style: GoogleFonts.gowunDodum(
                                      color: type == '객관형'
                                          ? const Color(0xFF4CDBFF)
                                          : Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (type == '단답형')
                        ..._options.asMap().entries.map((entry) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _correctAnswer = entry.key;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _correctAnswer == entry.key
                                              ? const Color(0xFF4CDBFF)
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        color: _correctAnswer == entry.key
                                            ? const Color(0xFF4CDBFF)
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${entry.key + 1}.',
                                    style: GoogleFonts.gowunDodum(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _optionControllers[entry.key],
                                      style: GoogleFonts.gowunDodum(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '답안 작성',
                                        hintStyle: GoogleFonts.gowunDodum(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF4CDBFF),
                                                width: 2,
                                              ),
                                            ),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      if (type == '객관형')
                        TextField(
                          controller: _optionControllers[0],
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: '정답을 입력하세요',
                            hintStyle: GoogleFonts.gowunDodum(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4CDBFF),
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 입력
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.gowunDodum(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: '퀴즈 제목을 입력하세요',
                        hintStyle: GoogleFonts.gowunDodum(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4CDBFF),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 내용 입력
                    TextField(
                      controller: _contentController,
                      minLines: 1,
                      maxLines: null,
                      style: GoogleFonts.gowunDodum(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: '퀴즈 내용을 입력하세요',
                        hintStyle: GoogleFonts.gowunDodum(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4CDBFF),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // 하단 바
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showAnswerInputBottomSheet('단답형');
                },
                child: Center(
                  child: Text(
                    '단답형',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showAnswerInputBottomSheet('객관형');
                },
                child: Center(
                  child: Text(
                    '객관형',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
