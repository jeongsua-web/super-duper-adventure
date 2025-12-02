import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/tile_object.dart';
import '../../services/tilemap_service.dart';

class TileMapScreen extends StatefulWidget {
  final String villageName;
  final String? villageId;

  const TileMapScreen({
    super.key,
    required this.villageName,
    this.villageId,
  });

  @override
  State<TileMapScreen> createState() => _TileMapScreenState();
}

class _TileMapScreenState extends State<TileMapScreen> {
  // 타일 크기 (픽셀)
  static const int TILE_SIZE = 50;
  
  // 타일맵 데이터
  late Map<String, dynamic> tileMapData;
  late List<TileObject> objects;
  
  // 확대/축소 컨트롤러
  late TransformationController _transformationController;
  
  // 서비스
  final TileMapService _tileMapService = TileMapService();
  
  late int gridWidth;
  late int gridHeight;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _loadTileMap();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // 타일맵 로드
  Future<void> _loadTileMap() async {
    try {
      if (widget.villageId == null || widget.villageId!.isEmpty) {
        setState(() {
          isLoading = false;
          gridWidth = 50;
          gridHeight = 50;
          objects = [];
        });
        return;
      }

      // Firestore에서 타일맵 로드
      tileMapData = await _tileMapService.loadTileMap(widget.villageId!);
      gridWidth = tileMapData['width'] ?? 50;
      gridHeight = tileMapData['height'] ?? 50;

      // 현재 사용자의 집 추가 (첫 입장 시)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await _tileMapService.addUserHouse(widget.villageId!, currentUser.uid);
        // 업데이트된 데이터 다시 로드
        tileMapData = await _tileMapService.loadTileMap(widget.villageId!);
      }

      objects = _tileMapService.getTileObjects(tileMapData);

      setState(() => isLoading = false);
    } catch (e) {
      print('타일맵 로드 에러: $e');
      setState(() {
        isLoading = false;
        gridWidth = 50;
        gridHeight = 50;
        objects = [];
      });
    }
  }

  // 객체 클릭 시
  void _onObjectTap(TileObject obj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${obj.getLabel()} (${obj.x}, ${obj.y})')),
    );
    // TODO: 객체별로 다른 화면으로 이동 로직 추가
  }

  // 타일 클릭 시
  void _onTileTap(int row, int col) {
    // 클릭 위치에 객체가 있는지 확인
    for (final obj in objects) {
      if (obj.x == col && obj.y == row) {
        _onObjectTap(obj);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.villageName} - 타일맵'),
          backgroundColor: const Color(0xFF4DDBFF),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.villageName} - 타일맵'),
        backgroundColor: const Color(0xFF4DDBFF),
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
                    Text(
                      '그리드: ${gridWidth}x${gridHeight}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.home, color: Color(0xFFFFB347)),
                    const SizedBox(height: 4),
                    Text(
                      '객체: ${objects.length}개',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 타일맵
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                child: Stack(
                  children: [
                    // 배경 이미지
                    Positioned(
                      width: gridWidth * TILE_SIZE.toDouble(),
                      height: gridHeight * TILE_SIZE.toDouble(),
                      child: SvgPicture.asset(
                        'assets/images/backgrand.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 타일맵 컨테이너
                    Container(
                      width: gridWidth * TILE_SIZE.toDouble(),
                      height: gridHeight * TILE_SIZE.toDouble(),
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          // 그리드 라인
                          CustomPaint(
                            painter: GridPainter(
                              gridWidth: gridWidth,
                              gridHeight: gridHeight,
                              tileSize: TILE_SIZE,
                            ),
                            size: Size(
                              gridWidth * TILE_SIZE.toDouble(),
                              gridHeight * TILE_SIZE.toDouble(),
                            ),
                          ),
                          // 타일들 (클릭 감지용)
                          ...List.generate(
                            gridHeight,
                            (row) => Positioned(
                              top: row * TILE_SIZE.toDouble(),
                              left: 0,
                              child: Row(
                                children: List.generate(
                                  gridWidth,
                                  (col) => GestureDetector(
                                    onTap: () => _onTileTap(row, col),
                                    child: Container(
                                      width: TILE_SIZE.toDouble(),
                                      height: TILE_SIZE.toDouble(),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // 객체 표시
                          ...objects.map(
                            (obj) => Positioned(
                              left: obj.x * TILE_SIZE.toDouble(),
                              top: obj.y * TILE_SIZE.toDouble(),
                              child: GestureDetector(
                                onTap: () => _onObjectTap(obj),
                                child: Container(
                                  width: TILE_SIZE.toDouble(),
                                  height: TILE_SIZE.toDouble(),
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
              ),
            ),
          ),
        ],
      ),
    );
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
