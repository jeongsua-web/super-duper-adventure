import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택 패키지
import 'dart:convert'; // Base64 변환용
import 'dart:typed_data'; // 이미지 데이터 처리용
import '../../services/village_role_service.dart';

class VillageCreateScreen extends StatefulWidget {
  const VillageCreateScreen({super.key});

  @override
  State<VillageCreateScreen> createState() => _VillageCreateScreenState();
}

class _VillageCreateScreenState extends State<VillageCreateScreen> {
  final TextEditingController _villageNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  
  // [★추가] 이미지 관련 변수
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes; // 미리보기용 이미지 데이터
  String? _base64Image; // Firestore 저장용 문자열

  @override
  void dispose() {
    _villageNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // [★추가] 이미지 선택 및 변환 함수
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500, // 용량 줄이기 위해 크기 제한
        maxHeight: 500,
        imageQuality: 50, // 화질 50%로 압축
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _base64Image = base64Encode(bytes); // 텍스트로 변환
        });
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러오지 못했습니다.')),
      );
    }
  }

  Future<void> _createVillage() async {
    final villageName = _villageNameController.text.trim();
    final description = _descriptionController.text.trim();

    if (villageName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('마을 이름을 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 사용자가 이미 생성한 마을이 있는지 확인
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data()?['villages'] != null) {
        final villages = userDoc.data()!['villages'];
        if (villages is List && villages.isNotEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('한 사람당 하나의 마을만 생성할 수 있습니다')),
            );
          }
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final roleService = VillageRoleService();

      // Firestore에 마을 정보 저장
      final villageRef = await FirebaseFirestore.instance.collection('villages').add({
        'name': villageName,
        'description': description,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'memberCount': 1,
        'image': _base64Image, // [★추가] 이미지 데이터 저장 (없으면 null)
      });

      // 생성자 역할 부여
      await roleService.setCreatorRole(villageRef.id, user.uid);

      // 사용자 정보 업데이트
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'villages': FieldValue.arrayUnion([villageRef.id]),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('마을이 생성되었습니다!')),
        );
        Navigator.of(context).pop(true); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('마을 생성 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '새 마을 만들기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Gowun Dodum',
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // 키보드가 올라올 때 화면이 잘리지 않도록 스크롤 추가
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [★추가] 마을 대표 이미지 선택 영역
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                      image: _selectedImageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_selectedImageBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImageBytes == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
                              const SizedBox(height: 8),
                              Text(
                                '마을 대표 사진 등록',
                                style: TextStyle(
                                  fontFamily: 'Gowun Dodum',
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          )
                        : null, // 이미지가 있으면 아이콘 숨김
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              const Text(
                '마을 이름',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _villageNameController,
                decoration: InputDecoration(
                  hintText: '마을 이름을 입력하세요',
                  filled: true,
                  fillColor: const Color(0xFFE7E7E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Gowun Dodum',
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '마을 소개 (선택)',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '마을에 대한 간단한 소개를 작성해주세요',
                  filled: true,
                  fillColor: const Color(0xFFE7E7E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Gowun Dodum',
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createVillage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC4ECF6),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          '마을 만들기',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}