import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void dispose() {
    _villageNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

      final roleService = VillageRoleService();

      // Create village in Firestore
      final villageRef = await FirebaseFirestore.instance.collection('villages').add({
        'name': villageName,
        'description': description,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'memberCount': 1,
      });

      // 생성자 역할 부여
      await roleService.setCreatorRole(villageRef.id, user.uid);

      // Add village to user's villages list
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
        Navigator.of(context).pop(true); // Return true to indicate success
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
            const Spacer(),
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
    );
  }
}
