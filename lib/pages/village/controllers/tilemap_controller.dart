import 'package:flutter/material.dart'; // Color 사용용
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/tile_object.dart';
import '../../../services/tilemap_service.dart';
import '../../../enums/tile_type.dart';

class TileMapController extends GetxController {
  final String villageName;
  final String? villageId;

  TileMapController({
    required this.villageName,
    this.villageId,
  });

  static const int tileSize = 50;

  // ★ 1. 바닥 타일 데이터 (2차원 배열)
  // 초기값은 빈 리스트, 나중에 loadTileMap에서 채움
  final RxList<List<TileType>> gridTiles = <List<TileType>>[].obs;

  // 2. 오브젝트 데이터 (기존 유지)
  final RxList<TileObject> objects = <TileObject>[].obs;
  
  final RxInt gridWidth = 10.obs;
  final RxInt gridHeight = 10.obs;
  final RxBool isLoading = true.obs;

  // 편집 모드 (관리자가 맵 꾸밀 때 사용)
  final RxBool isEditMode = false.obs;
  final Rx<TileType> selectedTileType = TileType.grass.obs; // 현재 선택된 브러시

  late TransformationController transformationController;
  final TileMapService _tileMapService = TileMapService();

  @override
  void onInit() {
    super.onInit();
    transformationController = TransformationController();
    loadTileMap();
  }

  Future<void> loadTileMap() async {
    isLoading.value = true;
    try {
      // (DB 로드 로직은 기존과 동일하다고 가정, 데이터가 없으면 기본맵 생성)
      // 실제로는 DB에 'tiles': [0, 0, 1, ...] 형태로 숫자 배열을 저장해야 함
      
      // ★ 맵 데이터가 없다고 가정하고 기본 맵 생성 (가장자리 로직 포함)
      _initializeDefaultMap(12, 12); // 예: 12x12 크기

      // ... (기존 객체 로드 로직 유지) ...
      
    } finally {
      isLoading.value = false;
    }
  }

  // ★ 기본 맵 생성 로직 (가장자리 막기)
  void _initializeDefaultMap(int width, int height) {
    gridWidth.value = width;
    gridHeight.value = height;

    List<List<TileType>> newMap = [];

    for (int y = 0; y < height; y++) {
      List<TileType> row = [];
      for (int x = 0; x < width; x++) {
        // 1. 가장자리 체크
        if (x == 0 || x == width - 1 || y == 0 || y == height - 1) {
          row.add(TileType.edge); // 가장자리는 절벽
        } 
        // 2. 나머지는 기본 잔디
        else {
          row.add(TileType.grass);
        }
      }
      newMap.add(row);
    }
    gridTiles.value = newMap;
  }

  // ★ 타일 클릭 시 (편집 모드 vs 일반 모드)
  void onTileTap(int row, int col) {
    // 1. 편집 모드라면 -> 바닥 타일 변경
    if (isEditMode.value) {
      // 가장자리는 못 바꾸게 하려면 조건 추가
      if (row == 0 || row == gridHeight.value - 1 || col == 0 || col == gridWidth.value - 1) {
        Get.snackbar("알림", "가장자리는 수정할 수 없습니다.");
        return;
      }
      
      // 타일 변경 (GetX 배열 갱신을 위해 복사본 사용 추천하지만 간단히)
      gridTiles[row][col] = selectedTileType.value;
      gridTiles.refresh(); // UI 강제 갱신
      return;
    }

    // 2. 일반 모드라면 -> 객체 상호작용
    // 클릭 위치에 객체가 있는지 확인
    for (final obj in objects) {
      if (obj.x == col && obj.y == row) {
        onObjectTap(obj);
        return;
      }
    }
    
    print("빈 땅 클릭: ${gridTiles[row][col]}");
  }

  void onObjectTap(TileObject obj) {
     Get.snackbar('정보', '${obj.getLabel()}');
  }

  // ★ 건물 건설 가능 여부 확인 함수
  bool canBuildAt(int x, int y) {
    // 1. 맵 범위 체크
    if (x < 0 || x >= gridWidth.value || y < 0 || y >= gridHeight.value) return false;
    
    // 2. 이미 건물이 있는지 체크
    bool hasBuilding = objects.any((obj) => obj.x == x && obj.y == y);
    if (hasBuilding) return false;

    // 3. 바닥 타일이 건설 가능한 땅인지 체크 (TileTypeExtension 활용)
    return gridTiles[y][x].isBuildable;
  }
  
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void goBack() => Get.back();
}