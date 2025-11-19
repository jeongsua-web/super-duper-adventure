import 'dart:io'; // 파일을 다루기 위해 추가
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 피커 추가
import 'package:firebase_storage/firebase_storage.dart'; // 스토리지 추가

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  String _selectedCategory = '일상';
  final List<String> _categories = ['일상', '게임', '취미', '퀴즈'];

  // [추가] 이미지와 공지사항 여부 변수
  File? _selectedImage;
  bool _isNotice = false;
  final ImagePicker _picker = ImagePicker();

  // [추가] 이미지 선택 함수
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // [수정] 저장 함수 (이미지 업로드 기능 포함)
  Future<void> _savePost() async {
    if (_titleController.text.isEmpty) {
      // ... (기존 유효성 검사) ...
      return;
    }

    setState(() { _isLoading = true; });

    try {
      String? imageUrl;

      // 1. 이미지가 선택되었다면 Storage에 업로드
      if (_selectedImage != null) {
        // 파일 이름 고유하게 만들기
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child(fileName);

        // 파일 업로드
        await storageRef.putFile(_selectedImage!);
        
        // 업로드된 URL 가져오기
        imageUrl = await storageRef.getDownloadURL();
      }

      // 2. Firestore에 데이터 저장 (imageUrl 포함)
      await FirebaseFirestore.instance.collection('posts').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _selectedCategory,
        'author': '익명', // TODO: 로그인 기능 후 수정
        'createdAt': FieldValue.serverTimestamp(),
        'isNotice': _isNotice,   // [추가] 공지 여부
        'imageUrl': imageUrl,   // [추가] 이미지 URL (없으면 null)
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('저장 실패: $e');
      // ... (에러 처리) ...
    } finally {
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
            // ... (카테고리, 제목, 내용 입력창은 기존 코드와 동일) ...
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
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '내용', border: OutlineInputBorder()),
              maxLines: 8,
            ),
            const SizedBox(height: 20),

            // [추가] 이미지 선택 버튼
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('이미지 선택'),
            ),
            
            // [추가] 이미지 미리보기
            if (_selectedImage != null)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 150,
                width: 150,
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            
            // [추가] 공지사항 체크박스
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