import 'dart:io'; // 파일을 다루기 위해 추가
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 피커 추가
import 'package:firebase_storage/firebase_storage.dart'; // 스토리지 추가
import 'package:google_fonts/google_fonts.dart';

class PostCreateScreen extends StatefulWidget {
  final String villageName;

  const PostCreateScreen({super.key, required this.villageName});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  String _selectedCategory = '일상';
  final List<String> _categories = ['일상', '게임', '취미'];

  // [추가] 이미지와 공지사항 여부 변수
  File? _selectedImage;
  bool _isNotice = false;
  final ImagePicker _picker = ImagePicker();

  // [추가] 이미지 선택 함수
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
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

    setState(() {
      _isLoading = true;
    });

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
        'isNotice': _isNotice, // [추가] 공지 여부
        'imageUrl': imageUrl, // [추가] 이미지 URL (없으면 null)
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('저장 실패: $e');
      // ... (에러 처리) ...
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

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

                  // 헤더 (X, 제목, 완료 버튼)
                  Padding(
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
                        Text(
                          widget.villageName,
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _savePost,
                          child: Icon(
                            Icons.edit,
                            color: _isLoading ? Colors.grey : Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 컨텐츠 영역
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 선택
                  Text(
                    '게시판 선택',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: GoogleFonts.gowunDodum(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 제목 입력
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: '글 제목을 입력하세요.',
                      hintStyle: GoogleFonts.gowunDodum(
                        color: const Color(0xFFAAAAAA),
                        fontSize: 16,
                      ),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 내용 입력
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: '글 내용을 입력하세요.',
                      hintStyle: GoogleFonts.gowunDodum(
                        color: const Color(0xFFAAAAAA),
                        fontSize: 16,
                      ),
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(Icons.camera_alt, () => _pickImage()),
                  _buildBottomButton(Icons.attach_file, () {}),
                  _buildBottomButton(Icons.text_fields, () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: Colors.black, size: 28),
      ),
    );
  }
}
