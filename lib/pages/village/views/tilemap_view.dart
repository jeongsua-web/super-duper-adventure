import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/tile_object.dart';
import '../../../enums/tile_type.dart';
import '../controllers/tilemap_controller.dart';

class TileMapView extends GetView<TileMapController> {
  const TileMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(controller.villageName),
          actions: [
            // 관리자용 편집 버튼 (테스트용)
            IconButton(
              icon: Icon(controller.isEditMode.value ? Icons.check : Icons.edit),
              onPressed: controller.toggleEditMode,
            )
          ],
        ),
        body: Column(
          children: [
            // (상단 정보 패널 생략 - 기존 코드 사용)
            
            // 편집 모드일 때만 보이는 팔레트
            if (controller.isEditMode.value)
              Container(
                height: 50,
                color: Colors.grey[200],
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: TileType.values.map((type) {
                    if (type == TileType.edge) return const SizedBox(); // 가장자리는 팔레트 제외
                    return GestureDetector(
                      onTap: () => controller.selectedTileType.value = type,
                      child: Obx(() => Container(
                        width: 50, height: 50,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: type.color,
                          border: controller.selectedTileType.value == type 
                            ? Border.all(color: Colors.red, width: 3) : null,
                        ),
                        child: Center(child: Text(type.name, style: const TextStyle(fontSize: 10))),
                      )),
                    );
                  }).toList(),
                ),
              ),

            // 메인 맵 뷰
            Expanded(
              child: Container(
                color: Colors.black, // 배경(우주/빈공간)
                child: InteractiveViewer(
                  transformationController: controller.transformationController,
                  minScale: 0.5, maxScale: 3.0, constrained: false,
                  child: GestureDetector(
                    onTapUp: (details) {
                      final tileSize = TileMapController.tileSize.toDouble();
                      final col = (details.localPosition.dx / tileSize).floor();
                      final row = (details.localPosition.dy / tileSize).floor();
                      if (col >= 0 && col < controller.gridWidth.value &&
                          row >= 0 && row < controller.gridHeight.value) {
                        controller.onTileTap(row, col);
                      }
                    },
                    child: SizedBox(
                      width: controller.gridWidth.value * TileMapController.tileSize.toDouble(),
                      height: controller.gridHeight.value * TileMapController.tileSize.toDouble(),
                      child: Stack(
                        children: [
                          // ★ 1층: 바닥 타일 (2중 for문 대신 Column/Row 사용)
                          Column(
                            children: List.generate(controller.gridHeight.value, (row) {
                              return Row(
                                children: List.generate(controller.gridWidth.value, (col) {
                                  return Obx(() {
                                    // 타일 타입 가져오기
                                    final type = controller.gridTiles[row][col];
                                    return Container(
                                      width: TileMapController.tileSize.toDouble(),
                                      height: TileMapController.tileSize.toDouble(),
                                      decoration: BoxDecoration(
                                        color: type.color, // ★ 여기에 이미지(AssetImage) 넣으면 됨
                                        border: Border.all(color: Colors.black12, width: 0.5), // 타일 구분선
                                      ),
                                    );
                                  });
                                }),
                              );
                            }),
                          ),

                          // ★ 2층: 오브젝트 (집, 건물)
                          Obx(() => Stack(
                            children: controller.objects.map((obj) => Positioned(
                              left: obj.x * TileMapController.tileSize.toDouble(),
                              top: obj.y * TileMapController.tileSize.toDouble(),
                              child: IgnorePointer( // 클릭은 상위 GestureDetector가 처리
                                child: Container(
                                  width: TileMapController.tileSize.toDouble(),
                                  height: TileMapController.tileSize.toDouble(),
                                  decoration: BoxDecoration(
                                    color: obj.type == ObjectType.system 
                                      ? Colors.purple.withOpacity(0.8) 
                                      : Colors.orange.withOpacity(0.8),
                                    shape: BoxShape.circle, // 건물은 동그랗게 표현 (예시)
                                    boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                                  ),
                                  child: Center(
                                    child: Text(
                                      obj.type == ObjectType.system ? '🏫' : '🏠',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            )).toList(),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}