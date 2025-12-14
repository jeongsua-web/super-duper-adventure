import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/tile_object.dart';
import '../../../services/tilemap_service.dart';

class TileMapController extends GetxController {
  final String villageName;
  final String? villageId;

  TileMapController({
    required this.villageName,
    this.villageId,
  });

  // 타일 크기 (픽셀)
  static const int tileSize = 50;

  // 타일맵 데이터
  final RxMap<String, dynamic> tileMapData = <String, dynamic>{}.obs;
  final RxList<TileObject> objects = <TileObject>[].obs;

  // 확대/축소 컨트롤러
  late TransformationController transformationController;

  // 서비스
  final TileMapService _tileMapService = TileMapService();

  final RxInt gridWidth = 10.obs;
  final RxInt gridHeight = 10.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    transformationController = TransformationController();
    loadTileMap();
  }

  @override
  void onClose() {
    transformationController.dispose();
    super.onClose();
  }

  // 타일맵 로드
  Future<void> loadTileMap() async {
    try {
      isLoading.value = true;

      if (villageId == null || villageId!.isEmpty) {
        gridWidth.value = 10;
        gridHeight.value = 10;
        objects.value = [];
        isLoading.value = false;
        return;
      }

      // Firestore에서 타일맵 로드
      final data = await _tileMapService.loadTileMap(villageId!);
      tileMapData.value = data;
      gridWidth.value = data['width'] ?? 10;
      gridHeight.value = data['height'] ?? 10;

      // 객체 리스트 먼저 가져오기
      objects.value = _tileMapService.getTileObjects(tileMapData);

      // 현재 사용자의 집 추가 (첫 입장 시 - 중복 방지)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // 이미 내 집이 있는지 확인
        final hasMyHouse = objects.any((obj) => 
          obj.type == ObjectType.house && obj.userId == currentUser.uid
        );
        
        // 집이 없을 때만 추가
        if (!hasMyHouse) {
          await _tileMapService.addUserHouse(villageId!, currentUser.uid);
          // 업데이트된 데이터 다시 로드
          final updatedData = await _tileMapService.loadTileMap(villageId!);
          tileMapData.value = updatedData;
          objects.value = _tileMapService.getTileObjects(tileMapData);
        }
      }
    } catch (e) {
      print('타일맵 로드 에러: $e');
      gridWidth.value = 10;
      gridHeight.value = 10;
      objects.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // 객체 클릭 시
  void onObjectTap(TileObject obj) {
    Get.snackbar(
      '객체 정보',
      '${obj.getLabel()} (${obj.x}, ${obj.y})',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: 객체별로 다른 화면으로 이동 로직 추가
  }

  // 타일 클릭 시
  void onTileTap(int row, int col) {
    // 클릭 위치에 객체가 있는지 확인
    for (final obj in objects) {
      if (obj.x == col && obj.y == row) {
        onObjectTap(obj);
        return;
      }
    }
  }

  void goBack() {
    Get.back();
  }
}
