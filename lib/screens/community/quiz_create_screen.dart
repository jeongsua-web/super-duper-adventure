import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // DB 저장 및 조회용
import '../village/village_view_screen.dart';

class QuizCreateScreen extends StatefulWidget {
  final String villageName;

  const QuizCreateScreen({super.key, required this.villageName});

  @override
  State<QuizCreateScreen> createState() => _QuizCreateScreenState();
}

class _QuizCreateScreenState extends State<QuizCreateScreen> {
  // 기본값을 '객관형'으로 설정 (4지선다)
  String _selectedType = '객관형'; 
  
  // 입력 컨트롤러
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  // 객관형 보기 (4개) 컨트롤러
  final List<TextEditingController> _optionControllers = List.generate(4, (index) => TextEditingController());
  // 단답형 정답 컨트롤러
  final TextEditingController _shortAnswerController = TextEditingController();

  // 객관형 정답 인덱스 (0, 1, 2, 3)
  int? _correctOptionIndex; 
  
  // 로딩 상태 (중복 클릭 방지)
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _shortAnswerController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// ★ 퀴즈 등록 함수 (중복 체크 로직 추가됨)
  Future<void> _registerQuiz() async {
    // 0. 로딩 중이면 클릭 막기
    if (_isLoading) return;

    // 1. 유효성 검사 (빈칸 확인)
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')));
      return;
    }

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    try {
      // ==========================================================
      // ★ [추가된 로직] 이미 진행 중인 퀴즈가 있는지 확인
      // ==========================================================
      final QuerySnapshot existingQuizzes = await FirebaseFirestore.instance
          .collection('quizzes')
          .where('villageName', isEqualTo: widget.villageName)
          .orderBy('createdAt', descending: true) // 최신순 정렬
          .limit(1) // 가장 최근 거 하나만 가져옴
          .get();

      if (existingQuizzes.docs.isNotEmpty) {
        final recentQuiz = existingQuizzes.docs.first.data() as Map<String, dynamic>;
        
        if (recentQuiz['createdAt'] != null) {
          final Timestamp lastTime = recentQuiz['createdAt'];
          final DateTime lastDate = lastTime.toDate();
          final DateTime now = DateTime.now();
          
          // 차이 계산 (시간)
          final int diffHours = now.difference(lastDate).inHours;

          // 24시간이 안 지났다면 등록 차단
          if (diffHours < 24) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('이미 진행 중인 퀴즈가 있습니다.\n${24 - diffHours}시간 뒤에 등록 가능합니다.'),
                backgroundColor: Colors.redAccent,
              ),
            );
            setState(() { _isLoading = false; });
            return; // 함수 종료 (저장 안 함)
          }
        }
      }
      // ==========================================================

      String finalAnswer = '';

      // 2. 유형별 정답 데이터 처리
      if (_selectedType == '객관형') {
        if (_correctOptionIndex == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('정답인 보기를 선택해주세요.')));
          setState(() { _isLoading = false; });
          return;
        }
        if (_optionControllers.any((c) => c.text.trim().isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('모든 보기를 입력해주세요.')));
          setState(() { _isLoading = false; });
          return;
        }
        // 정답 텍스트 저장
        finalAnswer = _optionControllers[_correctOptionIndex!].text.trim();

      } else {
        // 단답형
        if (_shortAnswerController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('정답을 입력해주세요.')));
          setState(() { _isLoading = false; });
          return;
        }
        finalAnswer = _shortAnswerController.text.trim();
      }

      // 3. Firebase Firestore에 저장
      await FirebaseFirestore.instance.collection('quizzes').add({
        'villageName': widget.villageName,
        'title': _titleController.text.trim(),
        'description': _contentController.text.trim(),
        'type': _selectedType,
        'answer': finalAnswer,
        'options': _selectedType == '객관형' 
            ? _optionControllers.map((c) => c.text.trim()).toList() 
            : [],
        'imageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      
      // 저장 성공
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('퀴즈가 등록되었습니다!')));
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 종료
        });
      }
    }
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                    Text(
                      widget.villageName,
                      style: GoogleFonts.gowunDodum(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 28), 
                  ],
                ),
              ),
            ),
          ),

          /// ================= 입력 폼 영역 =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. 제목 입력
                  Text('제목', style: GoogleFonts.gowunDodum(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '퀴즈 제목을 입력하세요',
                      hintStyle: GoogleFonts.gowunDodum(color: Colors.grey[400]),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4CDBFF), width: 2)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 2. 내용 입력
                  Text('문제 설명', style: GoogleFonts.gowunDodum(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '문제를 설명해주세요',
                      hintStyle: GoogleFonts.gowunDodum(color: Colors.grey[400]),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 3. 유형 선택 (탭 형태)
                  Row(
                    children: [
                      _buildTypeTab('객관형'),
                      const SizedBox(width: 10),
                      _buildTypeTab('단답형'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. 정답 및 보기 입력 영역
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedType == '객관형' ? _buildMultipleChoiceForm() : _buildShortAnswerForm(),
                  ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      /// ================= 하단 등록 버튼 =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _registerQuiz, // 로딩 중이면 버튼 비활성화
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CDBFF),
              disabledBackgroundColor: Colors.grey[300], // 비활성화 색상
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  '퀴즈 등록하기',
                  style: GoogleFonts.gowunDodum(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
          ),
        ),
      ),
    );
  }

  // 유형 선택 탭 위젯
  Widget _buildTypeTab(String type) {
    bool isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC4ECF6) : Colors.white,
            border: Border.all(color: isSelected ? const Color(0xFF4CDBFF) : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            type,
            style: GoogleFonts.gowunDodum(
              color: isSelected ? const Color(0xFF0080A0) : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // [객관형] 입력 폼
  Widget _buildMultipleChoiceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('보기를 입력하고 정답을 체크하세요.', style: GoogleFonts.gowunDodum(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 10),
        ...List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _correctOptionIndex = index;
                    });
                  },
                  child: Icon(
                    _correctOptionIndex == index ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: _correctOptionIndex == index ? const Color(0xFF4CDBFF) : Colors.grey[400],
                  ),
                ),
                const SizedBox(width: 10),
                Text('${index + 1}. ', style: GoogleFonts.gowunDodum()),
                Expanded(
                  child: TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      hintText: '보기 내용을 입력하세요',
                      hintStyle: GoogleFonts.gowunDodum(color: Colors.grey[300], fontSize: 14),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // [단답형] 입력 폼
  Widget _buildShortAnswerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('정답을 입력하세요.', style: GoogleFonts.gowunDodum(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 10),
        TextField(
          controller: _shortAnswerController,
          decoration: InputDecoration(
            hintText: '예: 사과',
            hintStyle: GoogleFonts.gowunDodum(color: Colors.grey[300]),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4CDBFF))),
          ),
        ),
      ],
    );
  }
}