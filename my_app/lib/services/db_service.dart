class DBService {
  // TODO: 실제 데이터베이스 연동 구현
  static final DBService _instance = DBService._internal();

  factory DBService() {
    return _instance;
  }

  DBService._internal();

  Future<void> initialize() async {
    // 데이터베이스 초기화 로직
  }

  // 여기에 CRUD 작업을 위한 메서드들을 추가
}