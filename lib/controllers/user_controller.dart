import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class UserController extends GetxController {
  // 서비스 인스턴스
  late final StorageService _storage;
  final AuthService _authService = AuthService();

  // 반응형 사용자 상태
  final Rx<User?> _user = Rx<User?>(null);

  // Getter
  User? get user => _user.value;
  Rx<User?> get userRx => _user;
  
  // 토큰 존재 여부 확인
  bool get hasToken {
    final token = _storage.readString('uToken');
    return token != null && token.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<StorageService>();
    _checkAutoLogin();
  }

  /// 자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    try {
      // 저장된 토큰(UID) 확인
      final token = _storage.readString('uToken');

      if (token == null || token.isEmpty) {
        debugPrint('자동 로그인 실패: 토큰 없음');
        return;
      }

      debugPrint('자동 로그인 시도: $token');

      // 토큰으로 유저 데이터 가져오기
      final userData = await _authService.getUserData(token);

      if (userData != null) {
        _user.value = userData;
        debugPrint('자동 로그인 성공: ${userData.name}');
        
        // 스플래시에서 처리하므로 여기서는 상태만 업데이트
      } else {
        debugPrint('자동 로그인 실패: 유저 데이터 없음');
        await logout();
      }
    } catch (e) {
      debugPrint('자동 로그인 오류: $e');
    }
  }

  /// 로그인
  Future<bool> login(String email, String password) async {
    try {
      final userData = await _authService.login(email, password);

      if (userData == null) {
        Get.snackbar('로그인 실패', '이메일 또는 비밀번호를 확인하세요');
        return false;
      }

      // 토큰(UID) 저장
      await _storage.saveString('uToken', userData.id);

      // 사용자 상태 업데이트
      _user.value = userData;

      Get.snackbar('로그인 성공', '${userData.name}님 환영합니다!');
      
      // 메인 홈으로 이동
      Get.offAllNamed(AppRoutes.mainHome);
      
      return true;
    } catch (e) {
      debugPrint('로그인 오류: $e');
      Get.snackbar('로그인 오류', '로그인 중 오류가 발생했습니다');
      return false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      // 저장된 토큰 삭제
      await _storage.remove('uToken');

      // Firebase Auth 로그아웃
      await _authService.signOut();

      // 사용자 상태 초기화
      _user.value = null;

      // 로그인 화면으로 이동 (스플래시 건너뛰기)
      Get.offAllNamed(AppRoutes.login);
      
      debugPrint('로그아웃 완료');
    } catch (e) {
      debugPrint('로그아웃 오류: $e');
      Get.snackbar('로그아웃 오류', '로그아웃 중 오류가 발생했습니다');
    }
  }

  /// 사용자 정보 업데이트
  void setUser(User user) {
    _user.value = user;
  }

  /// 사용자 정보 초기화
  void clearUser() {
    _user.value = null;
  }
}
