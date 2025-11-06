class AuthService {
  // TODO: 실제 인증 서비스 구현
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<bool> signIn(String email, String password) async {
    // 로그인 로직 구현
    return false;
  }

  Future<bool> signOut() async {
    // 로그아웃 로직 구현
    return false;
  }

  Future<bool> register(String email, String password) async {
    // 회원가입 로직 구현
    return false;
  }
}