import 'dart:async'; // 타임아웃 처리를 위해 필수
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
  
  // ★ 핵심: 초기값 false
  final RxBool isAutoLoginChecked = false.obs;

  // Getter
  User? get user => _user.value;
  Rx<User?> get userRx => _user;
  
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
      debugPrint('[UserController] 자동 로그인 체크 시작');
      
      final token = _storage.readString('uToken');

      if (token == null || token.isEmpty) {
        debugPrint('[UserController] 저장된 토큰 없음 -> 로그인 필요');
        return; // finally로 이동
      }

      debugPrint('[UserController] 토큰 발견: $token -> 서버 확인 중...');

      // ★ 5초 타임아웃 설정 (무한 로딩 방지)
      final userData = await _authService.getUserData(token)
          .timeout(const Duration(seconds: 5));

      if (userData != null) {
        _user.value = userData;
        debugPrint('[UserController] 자동 로그인 성공: ${userData.name}');
      } else {
        debugPrint('[UserController] 유저 데이터 없음 -> 토큰 삭제');
        await _storage.remove('uToken');
      }
    } on TimeoutException catch (_) {
      debugPrint('[UserController] ⚠️ 자동 로그인 시간 초과 (네트워크 지연)');
      // 필요하다면 여기서 스낵바를 띄우거나, 토큰을 유지한 채로 일단 로그인 화면으로 보낼 수도 있음
    } catch (e) {
      debugPrint('[UserController] ⚠️ 자동 로그인 오류: $e');
      await _storage.remove('uToken');
    } finally {
      // ★ 성공하든 실패하든 에러나든 무조건 실행!
      isAutoLoginChecked.value = true;
      debugPrint('[UserController] 체크 완료 플래그 변경됨 (true)');
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

      await _storage.saveString('uToken', userData.id);
      _user.value = userData;

      Get.snackbar('로그인 성공', '${userData.name}님 환영합니다!');
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
      await _storage.remove('uToken');
      await _authService.signOut();
      _user.value = null;
      Get.offAllNamed(AppRoutes.login);
      debugPrint('로그아웃 완료');
    } catch (e) {
      debugPrint('로그아웃 오류: $e');
    }
  }

  void setUser(User user) {
    _user.value = user;
  }

  void clearUser() {
    _user.value = null;
  }
}