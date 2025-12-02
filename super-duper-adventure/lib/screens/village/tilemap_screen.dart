import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  
  // 그리드 크기 (타일 개수)
  static const int GRID_WIDTH = 11;
  static const int GRID_HEIGHT = 10;
  
  // 타일 데이터 (0 = 빈 타일, 1 = 건물, 2 = 집)
  late List<List<int>> tileGrid;
  
  // 확대/축소 컨트롤러
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _initializeTileGrid();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _initializeTileGrid() {
    // 기본 빈 타일맵 생성
    tileGrid = List.generate(
      GRID_HEIGHT,
      (row) => List.generate(GRID_WIDTH, (col) => 0),
    );
    
    // 기본 건물 배치 (5,4), (5,6), (7,4), (7,6)
    tileGrid[5][4] = 1;
    tileGrid[5][6] = 1;
    tileGrid[7][4] = 1;
    tileGrid[7][6] = 1;
  }

  void _onTileTap(int row, int col) {
    setState(() {
      if (tileGrid[row][col] == 0) {
        // 빈 타일에 집 배치
        tileGrid[row][col] = 2;
      } else if (tileGrid[row][col] == 2) {
        // 집 제거
        tileGrid[row][col] = 0;
      }
      // 건물은 클릭해도 변경 불가
    });
  }

  Color _getTileColor(int tileType) {
    switch (tileType) {
      case 0: // 빈 타일
        return Colors.transparent;
      case 1: // 건물
        return const Color(0xFFFF6B6B);
      case 2: // 집
        return const Color(0xFFFFB347);
      default:
        return Colors.transparent;
    }
  }

  String _getTileLabel(int tileType) {
    switch (tileType) {
      case 0:
        return '';
      case 1:
        return '🏢';
      case 2:
        return '🏠';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      '그리드: ${GRID_WIDTH}x${GRID_HEIGHT}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.square, color: Color(0xFFFF6B6B)),
                    const SizedBox(height: 4),
                    const Text('건물 4개', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.home, color: Color(0xFFFFB347)),
                    const SizedBox(height: 4),
                    const Text('집 배치 가능', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          // 타일맵
          Expanded(
            child: Container(
              color: const Color(0xFF4DDBFF),
              child: Stack(
                children: [
                  // 배경 이미지
                  Positioned.fill(
                    child: SvgPicture.asset(
                      'assets/images/backgrand.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 타일맵
                  InteractiveViewer(
                    transformationController: _transformationController,
                    boundaryMargin: const EdgeInsets.all(100),
                    minScale: 0.5,
                    maxScale: 3.0,
                    constrained: false,
                    child: Container(
                      width: GRID_WIDTH * TILE_SIZE.toDouble(),
                      height: GRID_HEIGHT * TILE_SIZE.toDouble(),
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          // 그리드 라인
                          CustomPaint(
                            painter: GridPainter(
                              gridWidth: GRID_WIDTH,
                              gridHeight: GRID_HEIGHT,
                              tileSize: TILE_SIZE,
                            ),
                            size: Size(
                              GRID_WIDTH * TILE_SIZE.toDouble(),
                              GRID_HEIGHT * TILE_SIZE.toDouble(),
                            ),
                          ),
                          // 타일들
                          ...List.generate(
                            GRID_HEIGHT,
                            (row) => Positioned(
                              top: row * TILE_SIZE.toDouble(),
                              left: 0,
                              child: Row(
                                children: List.generate(
                                  GRID_WIDTH,
                                  (col) => GestureDetector(
                                    onTap: () => _onTileTap(row, col),
                                    child: Container(
                                      width: TILE_SIZE.toDouble(),
                                      height: TILE_SIZE.toDouble(),
                                      decoration: BoxDecoration(
                                        color: _getTileColor(tileGrid[row][col]),
                                        border: Border.all(
                                          color: const Color(0xFFAAFA52),
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getTileLabel(tileGrid[row][col]),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
      ..color = const Color(0xFFAAFA52).withOpacity(0.5)
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
