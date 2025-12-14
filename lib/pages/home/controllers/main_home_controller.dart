import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_routes.dart';

class MainHomeController extends GetxController {
  // PageController
  final Rx<PageController?> pageController = Rx<PageController?>(null);
  
  // 반응형 변수
  final RxInt currentIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isUserLoggedIn = false.obs;
  final RxString userName = '주민'.obs;
  final RxList<dynamic> villageIds = <dynamic>[].obs;
  final RxList<Map<String, dynamic>> villages = <Map<String, dynamic>>[].obs;
  
  final double viewportFraction = 0.55;
  
  User? get currentUser => FirebaseAuth.instance.currentUser;
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _listenToUserData();
  }
  
  @override
  void onClose() {
    pageController.value?.dispose();
    super.onClose();
  }
  
  // 인증 상태 확인
  void _checkAuthState() {
    final user = currentUser;
    isUserLoggedIn.value = user != null;
  }
  
  // 사용자 데이터 실시간 감지
  void _listenToUserData() {
    final user = currentUser;
    if (user == null) {
      isLoading.value = false;
      isUserLoggedIn.value = false;
      return;
    }
    
    isUserLoggedIn.value = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        final userData = snapshot.data();
        userName.value = userData?['displayName'] ?? 
                        user.displayName ?? 
                        user.email?.split('@')[0] ?? 
                        '주민';
        villageIds.value = userData?['villages'] ?? [];
        
        // 마을 데이터 가져오기
        if (villageIds.isNotEmpty) {
          await fetchAllVillages();
        } else {
          villages.clear();
          pageController.value?.dispose();
          pageController.value = null;
        }
      }
      isLoading.value = false;
    }, onError: (error) {
      print('Error listening to user data: $error');
      isLoading.value = false;
    });
  }
  
  // 모든 마을 데이터 가져오기
  Future<void> fetchAllVillages() async {
    final user = currentUser;
    if (user == null || villageIds.isEmpty) return;
    
    List<Map<String, dynamic>> allVillages = [];
    int chunkSize = 10;
    
    for (var i = 0; i < villageIds.length; i += chunkSize) {
      List<dynamic> chunk = villageIds.sublist(
        i,
        i + chunkSize > villageIds.length ? villageIds.length : i + chunkSize,
      );
      
      if (chunk.isNotEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('villages')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        
        for (var doc in snapshot.docs) {
          final data = doc.data();
          String creatorName = '알 수 없음';
          String creatorId = data['createdBy'] ?? '';
          
          try {
            if (creatorId.isNotEmpty) {
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(creatorId)
                  .get();
              creatorName = userDoc.data()?['displayName'] ?? '익명';
            }
          } catch (_) {}
          
          allVillages.add({
            'id': doc.id,
            'name': data['name'] ?? '이름 없음',
            'description': data['description'] ?? '',
            'creator': creatorName,
            'creatorId': creatorId,
            'image': data['image'],
          });
        }
      }
    }
    
    // 내 마을을 앞으로 정렬
    allVillages.sort((a, b) {
      bool isMyVillageA = a['creatorId'] == user.uid;
      bool isMyVillageB = b['creatorId'] == user.uid;
      if (isMyVillageA && !isMyVillageB) return -1;
      if (!isMyVillageA && isMyVillageB) return 1;
      return 0;
    });
    
    villages.value = allVillages;
    
    // PageController 초기화
    if (pageController.value == null && villages.isNotEmpty) {
      int initialPage = (10000 ~/ villages.length) * villages.length;
      pageController.value = PageController(
        initialPage: initialPage,
        viewportFraction: viewportFraction,
      );
    }
  }
  
  // 페이지 변경
  void onPageChanged(int index) {
    currentIndex.value = index;
  }
  
  // 홈으로 이동
  void goToHome() {
    if (pageController.value != null && villages.isNotEmpty) {
      int initialPage = (10000 ~/ villages.length) * villages.length;
      pageController.value!.animateToPage(
        initialPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
      );
    }
  }
  
  // 마을 생성 화면으로 이동
  void navigateToCreateVillage() {
    Get.toNamed('/village-create');
  }
  
  // 마을 상세로 이동
  void navigateToVillage(String villageId, String villageName) {
    Get.toNamed('/village', arguments: {
      'villageId': villageId,
      'villageName': villageName,
    });
  }
  
  // 설정 화면으로 이동
  void navigateToSettings() {
    print('[MainHomeController] 설정 화면으로 이동');
    Get.toNamed(AppRoutes.settings);
  }
  
  // 우편함으로 이동
  void navigateToMailbox() {
    Get.toNamed('/mailbox');
  }
  
  // MY마을 버튼 클릭
  void onMyVillageTap() {
    if (villages.isEmpty) {
      navigateToCreateVillage();
    } else {
      Get.snackbar(
        '알림',
        '생성한 마을이 없습니다!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
