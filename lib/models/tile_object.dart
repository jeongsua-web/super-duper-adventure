enum ObjectType {
  system,   // 게시판, 채팅, 캘린더 등
  house,    // 주민 집
}

class TileObject {
  final String id;
  final ObjectType type;
  final int x;
  final int y;
  final String? userId;  // HOUSE 타입일 때만 사용

  TileObject({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    this.userId,
  });

  // Firestore에서 받아올 때
  factory TileObject.fromFirestore(Map<String, dynamic> data) {
    return TileObject(
      id: data['id'] ?? '',
      type: data['type'] == 'SYSTEM' ? ObjectType.system : ObjectType.house,
      x: data['x'] ?? 0,
      y: data['y'] ?? 0,
      userId: data['userId'],
    );
  }

  // Firestore에 저장할 때
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'type': type == ObjectType.system ? 'SYSTEM' : 'HOUSE',
      'x': x,
      'y': y,
      if (userId != null) 'userId': userId,
    };
  }

  String getAssetPath() {
    if (type == ObjectType.system) {
      return 'assets/images/$id.png';
    } else {
      return 'assets/images/house.png';
    }
  }

  String getLabel() {
    if (type == ObjectType.system) {
      switch (id) {
        case 'bulletin':
          return '게시판';
        case 'chat':
          return '채팅';
        case 'calendar':
          return '캘린더';
        default:
          return id;
      }
    } else {
      return '집';
    }
  }
}
