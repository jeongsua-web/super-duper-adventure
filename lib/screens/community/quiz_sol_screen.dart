import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quiz_view_screen.dart';

class QuizSolScreen extends StatefulWidget {
  final String villageName;
  final Map<String, dynamic> quizData; 
  final String docId; 

  const QuizSolScreen({
    super.key,
    required this.villageName,
    required this.quizData,
    required this.docId,
  });

  @override
  State<QuizSolScreen> createState() => _QuizSolScreenState();
}

class _QuizSolScreenState extends State<QuizSolScreen> {
  final TextEditingController _answerController = TextEditingController();
  int? _selectedOptionIndex; 
  
  // 로딩 상태 변수들
  bool _isChecking = true; // 처음 들어왔을 때 확인 중
  bool _isSubmitting = false; // ★ 정답 제출 중인지 확인 (중복 클릭 방지)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfAlreadySolved();
    });
  }

  /// 1. 들어오자마자 이미 풀었는지 확인
  Future<void> _checkIfAlreadySolved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() { _isChecking = false; });
      return;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.docId)
          .collection('solvers')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        // 이미 푼 기록이 있으면 즉시 쫓아냄
        if (!mounted) return;
        _showAlreadySolvedDialog();
      } else {
        setState(() { _isChecking = false; });
      }
    } catch (e) {
      print("체크 중 에러: $e");
      setState(() { _isChecking = false; });
    }
  }

  /// 2. 결과 저장 함수 (무조건 성공해야 함)
  Future<bool> _recordSolver({required bool isCorrect}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('로그인이 필요합니다.')));
      return false;
    }

    try {
      // ★ await를 사용하여 저장이 끝날 때까지 기다림
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.docId)
          .collection('solvers')
          .doc(user.uid)
          .set({
        'solvedAt': FieldValue.serverTimestamp(),
        'userName': user.displayName ?? '익명',
        'uid': user.uid,
        'isCorrect': isCorrect, 
      });
      return true; // 저장 성공
    } catch (e) {
      print("저장 실패 에러: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('결과 저장 실패: $e\n(Firebase 규칙을 확인해주세요)')));
      return false; // 저장 실패
    }
  }

  /// 이미 풀었을 때 뜨는 알림창
  void _showAlreadySolvedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('알림', style: GoogleFonts.gowunDodum(fontWeight: FontWeight.bold)),
        content: Text('이미 참여한 퀴즈입니다.\n결과 화면으로 이동합니다.', style: GoogleFonts.gowunDodum()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 팝업 닫고
              _goToResultScreen(); // 이동
            },
            child: Text('확인', style: GoogleFonts.gowunDodum(color: const Color(0xFF4CDBFF))),
          ),
        ],
      ),
    );
  }

  /// 결과 화면으로 이동하는 함수 (중복 코드 제거)
  void _goToResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizViewScreen(
          villageName: widget.villageName,
          quizData: widget.quizData,
        ),
      ),
    );
  }

  // 남은 시간 계산
  String _calculateTimeLeft() {
    try {
      if (widget.quizData['createdAt'] == null) return "-";
      final createdAt = (widget.quizData['createdAt'] is Timestamp) 
          ? (widget.quizData['createdAt'] as Timestamp).toDate()
          : Timestamp.now().toDate();
      final deadline = createdAt.add(const Duration(hours: 24));
      final now = DateTime.now();
      final difference = deadline.difference(now);
      if (difference.isNegative) return "시간 초과";
      return "${difference.inHours}시간 ${difference.inMinutes % 60}분";
    } catch (e) {
      return "-";
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  // ⭕ 정답 팝업
  void _showCorrectDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFC4ECF6), 
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text('정답입니다!', style: GoogleFonts.gowunDodum(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text('축하합니다!\n친밀도가 상승합니다!', textAlign: TextAlign.center, style: GoogleFonts.gowunDodum(fontSize: 16)),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); 
                      _goToResultScreen();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
                    child: Text('돌아가기', style: GoogleFonts.gowunDodum(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ❌ 오답 팝업
  void _showWrongDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0E0), 
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                const Icon(Icons.cancel_outlined, size: 50, color: Colors.redAccent),
                const SizedBox(height: 10),
                Text('오답입니다!', style: GoogleFonts.gowunDodum(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text('아쉽지만 정답이 아닙니다.\n결과 화면으로 이동합니다.', textAlign: TextAlign.center, style: GoogleFonts.gowunDodum(fontSize: 16)),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); 
                      _goToResultScreen();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
                    child: Text('확인', style: GoogleFonts.gowunDodum(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중이거나 제출 중이면 터치 막음
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String title = widget.quizData['title'] ?? '제목 없음';
    final String description = widget.quizData['description'] ?? '설명이 없습니다.';
    final String imageUrl = widget.quizData['imageUrl'] ?? '';
    final String realAnswer = widget.quizData['answer'] ?? ''; 
    final String type = widget.quizData['type'] ?? '단답형';
    final List<dynamic> options = widget.quizData['options'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: AbsorbPointer( // ★ 제출 중(_isSubmitting)일 때 화면 터치 막기
        absorbing: _isSubmitting,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 헤더
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
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
                            Text(widget.villageName, style: GoogleFonts.gowunDodum(fontSize: 18)),
                            const SizedBox(width: 28), 
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 문제 영역
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4CDBFF)),
                          ),
                          child: Text(type, style: GoogleFonts.gowunDodum(color: const Color(0xFF00838F), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),

                        Text(title, style: GoogleFonts.gowunDodum(fontSize: 24)),
                        const SizedBox(height: 20),

                        if (imageUrl.isNotEmpty)
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(imageUrl, height: 250, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                            ),
                          ),
                        
                        const SizedBox(height: 30),
                        Center(child: Text(description, textAlign: TextAlign.center, style: GoogleFonts.gowunDodum(fontSize: 18, height: 1.5))),
                        const SizedBox(height: 20),
                        Divider(color: Colors.grey[300]),
                        const SizedBox(height: 20),

                        // 입력 UI
                        _buildAnswerInput(type, options),
                        
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('남은 시간', style: GoogleFonts.gowunDodum(fontSize: 14)),
                            Text(_calculateTimeLeft(), style: GoogleFonts.gowunDodum(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // ★ 제출 버튼
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : () async { // 로딩 중이면 버튼 비활성화
                              String userAnswer = '';
                              if (type == '객관형') {
                                if (_selectedOptionIndex != null && _selectedOptionIndex! < options.length) {
                                  userAnswer = options[_selectedOptionIndex!].toString();
                                }
                              } else {
                                userAnswer = _answerController.text.trim();
                              }

                              if (userAnswer.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('정답을 입력(선택)해주세요.')));
                                return;
                              }

                              // 1. 로딩 시작 (화면 터치 막힘)
                              setState(() { _isSubmitting = true; });

                              // 2. 기록 저장 (DB 쓰기)
                              bool isCorrect = (userAnswer == realAnswer);
                              bool success = await _recordSolver(isCorrect: isCorrect);

                              // 3. 로딩 끝
                              setState(() { _isSubmitting = false; });

                              if (success) {
                                // 저장이 확실히 된 경우에만 팝업 띄움
                                if (isCorrect) {
                                  if(mounted) _showCorrectDialog();
                                } else {
                                  if(mounted) _showWrongDialog();
                                }
                              } else {
                                // 저장 실패 (권한 문제 등)
                                // SnackBar가 위에서 떴을 것임.
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CDBFF),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                            child: _isSubmitting 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                                : Text('정답제출', style: GoogleFonts.gowunDodum(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 전체 로딩 오버레이 (확실하게 막기 위해)
            if (_isSubmitting)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput(String type, List<dynamic> options) {
    if (type == '객관형') {
      if (options.isEmpty) return Center(child: Text("보기가 없습니다.", style: GoogleFonts.gowunDodum(color: Colors.red)));

      return Column(
        children: options.asMap().entries.map((entry) {
          final int idx = entry.key;
          final String optText = entry.value.toString();
          final bool isSelected = _selectedOptionIndex == idx; 

          return GestureDetector(
            onTap: () {
              if(!_isSubmitting) setState(() { _selectedOptionIndex = idx; });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC4ECF6) : Colors.white, 
                border: Border.all(color: isSelected ? const Color(0xFF4CDBFF) : Colors.grey[300]!, width: isSelected ? 2 : 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? const Color(0xFF4CDBFF) : Colors.grey[400]),
                  const SizedBox(width: 12),
                  Expanded(child: Text(optText, style: GoogleFonts.gowunDodum(fontSize: 16, color: isSelected ? const Color(0xFF0080A0) : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
        child: TextField(
          controller: _answerController,
          enabled: !_isSubmitting,
          style: GoogleFonts.gowunDodum(fontSize: 16),
          decoration: InputDecoration(
            hintText: '정답을 입력하세요.',
            hintStyle: GoogleFonts.gowunDodum(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }
  }
}