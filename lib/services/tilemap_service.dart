import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tile_object.dart';

class TileMapService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 타일맵 데이터 로드
  Future<Map<String, dynamic>> loadTileMap(String villageId) async {
    try {
      final doc = await _db
          .collection('villages')
          .doc(villageId)
          .collection('settings')
          .doc('tilemap')
          .get();

      if (doc.exists) {
        final data = doc.data() ?? _createDefaultTileMap();
        
        // 기존 50x50 데이터를 10x10으로 초기화
        if ((data['width'] ?? 0) == 50 || (data['height'] ?? 0) == 50) {
          print('기존 50x50 타일맵을 10x10으로 초기화합니다');
          final defaultMap = _createDefaultTileMap();
          await _db
              .collection('villages')
              .doc(villageId)
              .collection('settings')
              .doc('tilemap')
              .set(defaultMap);
          return defaultMap;
        }
        
        return data;
      }
      return _createDefaultTileMap();
    } catch (e) {
      print('타일맵 로드 실패: $e');
      return _createDefaultTileMap();
    }
  }

  // 기본 타일맵 생성
  Map<String, dynamic> _createDefaultTileMap() {
    return {
      'width': 10,
      'height': 10,
      'tiles': List.filled(100, 0), // 10x10 = 100
      'objects': [
        {
          'id': 'bulletin',
          'type': 'SYSTEM',
          'x': 2,
          'y': 1,
        },
        {
          'id': 'chat',
          'type': 'SYSTEM',
          'x': 4,
          'y': 1,
        },
        {
          'id': 'calendar',
          'type': 'SYSTEM',
          'x': 2,
          'y': 3,
        },
        {
          'id': 'owner_house',
          'type': 'HOUSE',
          'userId': 'owner123',
          'x': 5,
          'y': 5,
        },
      ],
    };
  }

  // 사용자 집 추가 (첫 입장 시)
  Future<void> addUserHouse(String villageId, String userId) async {
    try {
      final tileMapDoc = _db
          .collection('villages')
          .doc(villageId)
          .collection('settings')
          .doc('tilemap');

      final doc = await tileMapDoc.get();
      final data = doc.data() ?? _createDefaultTileMap();

      // 집이 이미 있는지 확인
      final objects = List<Map<String, dynamic>>.from(data['objects'] ?? []);
      final userHouseExists =
          objects.any((obj) => obj['userId'] == userId && obj['type'] == 'HOUSE');

      if (userHouseExists) return; // 이미 집이 있으면 종료

      // 빈 타일 탐색
      final position = _findEmptyTile(data);

      // 새 집 객체 생성
      final newHouse = {
        'id': 'house_$userId',
        'type': 'HOUSE',
        'userId': userId,
        'x': position['x'],
        'y': position['y'],
      };

      objects.add(newHouse);
      data['objects'] = objects;

      // DB에 저장
      await tileMapDoc.set(data);
    } catch (e) {
      print('사용자 집 추가 실패: $e');
    }
  }

  // 빈 타일 찾기
  Map<String, int> _findEmptyTile(Map<String, dynamic> tileMapData) {
    final width = tileMapData['width'] as int? ?? 50;
    final height = tileMapData['height'] as int? ?? 50;
    final objects = List<Map<String, dynamic>>.from(tileMapData['objects'] ?? []);

    // 기존 객체들의 위치 수집
    final occupiedPositions = <String>{};
    for (final obj in objects) {
      occupiedPositions.add('${obj['x']},${obj['y']}');
    }

    // 빈 타일 찾기 (랜덤)
    final random = _randomPositionExcluding(width, height, occupiedPositions);
    return random;
  }

  // 제외할 위치를 제외한 랜덤 위치 찾기
  Map<String, int> _randomPositionExcluding(
    int width,
    int height,
    Set<String> occupied,
  ) {
    // 간단하게 특정 영역에서 랜덤하게 배치
    // 실제로는 더 정교한 알고리즘 필요
    late int x, y;
    int attempts = 0;
    do {
      x = (25 + (attempts % 10)) % width; // 중앙 우측
      y = (15 + (attempts % 10)) % height; // 중앙 하단
      attempts++;
    } while (occupied.contains('$x,$y') && attempts < 100);

    return {'x': x, 'y': y};
  }

  // 타일맵 데이터 저장
  Future<void> saveTileMap(String villageId, Map<String, dynamic> tileMapData) async {
    try {
      await _db
          .collection('villages')
          .doc(villageId)
          .collection('settings')
          .doc('tilemap')
          .set(tileMapData);
    } catch (e) {
      print('타일맵 저장 실패: $e');
    }
  }

  // 객체 리스트 가져오기
  List<TileObject> getTileObjects(Map<String, dynamic> tileMapData) {
    final objectsData = List<Map<String, dynamic>>.from(tileMapData['objects'] ?? []);
    return objectsData.map((obj) => TileObject.fromFirestore(obj)).toList();
  }
}
