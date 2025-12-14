import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../models/tile_object.dart';
import '../controllers/tilemap_controller.dart';

class TileMapView extends GetView<TileMapController> {
  const TileMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${controller.villageName} - 타일맵'),
            backgroundColor: const Color(0xFF4DDBFF),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('${controller.villageName} - 타일맵'),
          backgroundColor: const Color(0xFF4DDBFF),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.goBack,
          ),
        ),
        body: Column(
          children: [
            // 정보 패널
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF0F0F0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.grid_on, color: Colors.blue),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            '그리드: ${controller.gridWidth}x${controller.gridHeight}',
                            style: const TextStyle(fontSize: 12),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.home, color: Color(0xFFFFB347)),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                            '객체: ${controller.objects.length}개',
                            style: const TextStyle(fontSize: 12),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            // 타일맵
            Expanded(
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: Obx(() => InteractiveViewer(
                      transformationController: controller.transformationController,
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.5,
                      maxScale: 3.0,
                      constrained: false,
                      child: Stack(
                        children: [
                          // 배경 이미지
                          Positioned(
                            width: controller.gridWidth.value * TileMapController.tileSize.toDouble(),
                            height: controller.gridHeight.value * TileMapController.tileSize.toDouble(),
                            child: SvgPicture.asset(
                              'assets/images/backgrand.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // 타일맵 컨테이너
                          Container(
                            width: controller.gridWidth.value * TileMapController.tileSize.toDouble(),
                            height: controller.gridHeight.value * TileMapController.tileSize.toDouble(),
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                // 그리드 라인
                                CustomPaint(
                                  painter: GridPainter(
                                    gridWidth: controller.gridWidth.value,
                                    gridHeight: controller.gridHeight.value,
                                    tileSize: TileMapController.tileSize,
                                  ),
                                  size: Size(
                                    controller.gridWidth.value * TileMapController.tileSize.toDouble(),
                                    controller.gridHeight.value * TileMapController.tileSize.toDouble(),
                                  ),
                                ),
                                // 타일들 (클릭 감지용)
                                ...List.generate(
                                  controller.gridHeight.value,
                                  (row) => Positioned(
                                    top: row * TileMapController.tileSize.toDouble(),
                                    left: 0,
                                    child: Row(
                                      children: List.generate(
                                        controller.gridWidth.value,
                                        (col) => GestureDetector(
                                          onTap: () => controller.onTileTap(row, col),
                                          child: Container(
                                            width: TileMapController.tileSize.toDouble(),
                                            height: TileMapController.tileSize.toDouble(),
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // 객체 표시
                                ...controller.objects.map(
                                  (obj) => Positioned(
                                    left: obj.x * TileMapController.tileSize.toDouble(),
                                    top: obj.y * TileMapController.tileSize.toDouble(),
                                    child: GestureDetector(
                                      onTap: () => controller.onObjectTap(obj),
                                      child: Container(
                                        width: TileMapController.tileSize.toDouble(),
                                        height: TileMapController.tileSize.toDouble(),
                                        decoration: BoxDecoration(
                                          color: obj.type == ObjectType.system
                                              ? Colors.blue.withOpacity(0.7)
                                              : Colors.orange.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            obj.type == ObjectType.system ? '📌' : '🏠',
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GridPainter extends CustomPainter {
  final int gridWidth;
  final int gridHeight;
  final int tileSize;

  GridPainter({
    required this.gridWidth,
    required this.gridHeight,
    required this.tileSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFAAFA52).withOpacity(0.3)
      ..strokeWidth = 0.5;

    // 수평선
    for (int i = 0; i <= gridHeight; i++) {
      canvas.drawLine(
        Offset(0, i * tileSize.toDouble()),
        Offset(gridWidth * tileSize.toDouble(), i * tileSize.toDouble()),
        paint,
      );
    }

    // 수직선
    for (int i = 0; i <= gridWidth; i++) {
      canvas.drawLine(
        Offset(i * tileSize.toDouble(), 0),
        Offset(i * tileSize.toDouble(), gridHeight * tileSize.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.gridWidth != gridWidth ||
        oldDelegate.gridHeight != gridHeight ||
        oldDelegate.tileSize != tileSize;
  }
}
