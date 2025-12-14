import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/guestbook_view.dart';
import '../../../models/user.dart' as models;

class ResidentProfileController extends GetxController {
  final String userId; // 주민의 userId
  final String villageName;

  ResidentProfileController({
    required this.userId,
    required this.villageName,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 주민 정보
  final Rx<models.User?> resident = Rx<models.User?>(null);
  final RxBool isLoading = true.obs;
  
  // 친밀도 (0.0 ~ 1.0)
  final RxDouble intimacy = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadResidentData();
  }

  // 주민 데이터 로드
  Future<void> loadResidentData() async {
    try {
      isLoading.value = true;
      
      // 사용자 정보 가져오기
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        resident.value = models.User(
          id: userDoc.id,
          username: data['username'] ?? '',
          name: data['name'] ?? '알 수 없음',
          realName: data['realName'] ?? data['name'] ?? '알 수 없음',
          email: data['email'] ?? '',
          gender: data['gender'],
          job: data['job'],
        );
      }

      // TODO: 친밀도 데이터 가져오기 (현재는 임시값)
      // 실제로는 Firestore에서 친밀도 컬렉션을 만들어서 관리
      intimacy.value = 0.5; // 임시값
      
    } catch (e) {
      print('주민 데이터 로드 실패: $e');
      Get.snackbar('오류', '주민 정보를 불러올 수 없습니다');
    } finally {
      isLoading.value = false;
    }
  }

  // 뒤로가기
  void goBack() {
    Get.back();
  }

  // 방명록 가기
  void goToGuestbook() {
    if (resident.value != null) {
      Get.to(() => GuestbookScreen(residentName: resident.value!.name));
    }
  }

  // 스티커 붙이기
  void attachSticker() {
    // TODO: 실제 스티커 기능 구현
    Get.snackbar(
      '스티커',
      '스티커 붙이기 기능 준비 중입니다',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // 친밀도 퍼센트 (0~100)
  int get intimacyPercent => (intimacy.value * 100).round();
}
