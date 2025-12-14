import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../models/village_member.dart';
import '../../../services/village_role_service.dart';

class VillageViewController extends GetxController {
  final String? villageName;
  final String? villageId;

  VillageViewController({this.villageName, this.villageId});

  final _firestore = FirebaseFirestore.instance;
  final _roleService = VillageRoleService();

  final Rx<String?> resolvedVillageId = Rx<String?>(null);
  final RxBool isLoading = true.obs;
  final Rx<VillageMember?> currentUserRole = Rx<VillageMember?>(null);

  @override
  void onInit() {
    super.onInit();
    resolveVillageId();
  }

  Future<void> resolveVillageId() async {
    if (villageId != null && villageId!.isNotEmpty) {
      resolvedVillageId.value = villageId;
      await loadUserRole();
      isLoading.value = false;
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('villages')
          .where('name', isEqualTo: villageName)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        resolvedVillageId.value = querySnapshot.docs.first.id;
        await loadUserRole();
      }
    } catch (e) {
      Get.snackbar('오류', '마을 정보를 불러올 수 없습니다: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserRole() async {
    if (resolvedVillageId.value == null) return;
    
    try {
      final role = await _roleService.getCurrentUserRole(resolvedVillageId.value!);
      currentUserRole.value = role;
    } catch (e) {
      print('사용자 역할 로드 실패: $e');
    }
  }

  void goToResidentProfile() {
    Get.toNamed('/resident-profile', arguments: {
      'villageName': villageName ?? '마을',
    });
  }

  void goToBoard() {
    Get.toNamed('/board', arguments: {
      'villageName': villageName ?? '마을',
      'villageId': resolvedVillageId.value ?? '',
    });
  }

  void goToCreatorHome() {
    Get.toNamed('/creator-home', arguments: {
      'villageName': villageName ?? '마을',
    });
  }

  void goToCalendar() {
    Get.toNamed('/calendar', arguments: {
      'villageName': villageName ?? '마을',
      'villageId': resolvedVillageId.value,
    });
  }

  void goToChatList() {
    Get.toNamed('/chat-list');
  }

  void goToTileMap() {
    if (resolvedVillageId.value != null) {
      Get.toNamed('/tilemap', arguments: {
        'villageName': villageName ?? '마을',
        'villageId': resolvedVillageId.value,
      });
    }
  }

  void goToSettings() {
    if (currentUserRole.value?.isCreator != true) {
      Get.snackbar('알림', '마을 생성자만 접근 가능합니다');
      return;
    }
    
    if (resolvedVillageId.value != null) {
      Get.toNamed('/village-settings', arguments: {
        'villageId': resolvedVillageId.value!,
        'villageName': villageName ?? '마을',
      });
    }
  }

  void goBack() {
    Get.back();
  }
}
