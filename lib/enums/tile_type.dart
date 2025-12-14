import 'package:flutter/material.dart';

enum TileType {
  grass,    // 잔디 (건물 건설 가능)
  dirt,     // 흙 (건물 건설 가능)
  water,    // 물 (건물 건설 불가)
  forest,   // 숲 (건물 건설 불가)
  edge,     // 가장자리/절벽 (건물 건설 불가, 진입 불가)
}

// 타일 속성 도우미 (Extension)
extension TileTypeExtension on TileType {
  
  // 1. 건설 가능한 땅인지 확인
  bool get isBuildable {
    return this == TileType.grass || this == TileType.dirt;
  }
  
  // 2. 타일 색상 반환 (이미지 없을 때 임시용)
  Color get color {
    switch (this) {
      case TileType.grass: return Colors.green[300]!;
      case TileType.dirt: return Colors.brown[300]!;
      case TileType.water: return Colors.blue[300]!;
      case TileType.forest: return Colors.green[800]!;
      case TileType.edge: return Colors.grey[800]!;
    }
  }

  // 3. UI 표시용 한글 이름 (선택 사항)
  String get label {
    switch (this) {
      case TileType.grass: return '잔디';
      case TileType.dirt: return '흙';
      case TileType.water: return '물';
      case TileType.forest: return '숲';
      case TileType.edge: return '절벽';
    }
  }
}