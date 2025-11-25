import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// villageId를 받기 위한 생성자 추가
class PostCreateScreen extends StatefulWidget {
  final String villageId; 

  const PostCreateScreen({
    super.key,
    required this.villageId,
  });

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  String _selectedCategory = '일상';
  final List<String> _categories = ['일상', '게임', '취미', '퀴즈'];

  bool _isNotice = false; // 공지사항 여부 변수

  // [핵심] 저장 함수 (Storage 로직 제거, 순수 Firestore 저장)
  Future<void> _savePost() async {
    // 1. 필수 필드 검사
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해 주세요.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      // 2. Firestore에 데이터 저장 시도
      // 경로: villages/{widget.villageId}/posts/
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .add({
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _selectedCategory,
        'author': '익명', // TODO: 로그인 기능 후 실제 사용자 정보로 교체
        'createdAt': FieldValue.serverTimestamp(),
        'isNotice': _isNotice,
        'imageUrl': null, // Storage를 사용하지 않으므로 null 처리
        'commentCount': 0, 
      });

      // 3. 성공 시 화면 닫기
      if (mounted) Navigator.pop(context);
      
    } catch (e) {
      // 🚨 [핵심] 에러 발생 시 사용자에게 메시지 표시
      print('게시글 저장 실패: $e'); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시글 저장 실패: ${e.toString()}\n(보안 규칙 확인 필요)')),
        );
      }
    } finally {
      // 4. 로딩 상태 해제
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 글 작성')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 선택 드롭다운
            const Text('카테고리 선택'),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() { _selectedCategory = newValue!; });
              },
            ),
            const SizedBox(height: 20),
            
            // 제목 입력 필드
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            
            // 내용 입력 필드
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '내용', border: OutlineInputBorder()),
              maxLines: 8,
            ),
            const SizedBox(height: 20),

            // 공지사항 체크박스
            CheckboxListTile(
              title: const Text('공지사항으로 등록'),
              value: _isNotice,
              onChanged: (bool? value) {
                setState(() {
                  _isNotice = value ?? false;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // 게시글 올리기 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePost,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('게시글 올리기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}