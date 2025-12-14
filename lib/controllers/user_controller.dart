import 'dart:async'; // 타임아웃 처리를 위해 필수
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class UserController extends GetxController {
  // 서비스 인스턴스
  late final StorageService _storage;
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      debugPrint('[UserController] 토큰 발견: $token -> Firebase Auth 확인 중...');

      // Firebase Auth가 초기화될 때까지 대기 (최대 3초)
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
      int waitCount = 0;
      
      while (currentUser == null && waitCount < 15) {
        debugPrint('[UserController] Firebase Auth 초기화 대기 중... (${waitCount + 1}/15)');
        await Future.delayed(const Duration(milliseconds: 200));
        currentUser = auth.FirebaseAuth.instance.currentUser;
        waitCount++;
      }
      
      if (currentUser != null && currentUser.uid == token) {
        debugPrint('[UserController] Firebase Auth 세션 유효함');
        
        // 일단 기본 사용자 정보로 설정 (즉시 로그인)
        _user.value = User(
          id: token,
          username: currentUser.email?.split('@')[0] ?? '사용자',
          name: currentUser.email?.split('@')[0] ?? '사용자',
          realName: currentUser.email?.split('@')[0] ?? '사용자',
          email: currentUser.email ?? '',
        );
        
        // Firestore에서 추가 정보 가져오기 (백그라운드에서)
        _loadUserDataFromFirestore(token, currentUser);
        
        debugPrint('[UserController] 자동 로그인 성공: ${_user.value!.name}');
      } else {
        debugPrint('[UserController] Firebase Auth 세션 없음 -> 토큰 삭제');
        await _storage.remove('uToken');
      }
    } on TimeoutException catch (_) {
      debugPrint('[UserController] ⚠️ 자동 로그인 시간 초과 (네트워크 지연)');
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
      debugPrint('[UserController] 로그아웃 시작');
      await _storage.remove('uToken');
      await _authService.signOut();
      _user.value = null;
      Get.offAllNamed(AppRoutes.login);
      debugPrint('[UserController] 로그아웃 완료');
    } catch (e) {
      debugPrint('[UserController] 로그아웃 오류: $e');
    }
  }

  void setUser(User user) {
    _user.value = user;
  }

  void clearUser() {
    _user.value = null;
  }

  /// Firestore에서 사용자 정보 로드 (백그라운드)
  Future<void> _loadUserDataFromFirestore(String userId, auth.User currentUser) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get()
          .timeout(const Duration(seconds: 10));
      
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        _user.value = User(
          id: userId,
          username: data['username'] ?? currentUser.email?.split('@')[0] ?? '사용자',
          name: data['name'] ?? currentUser.email?.split('@')[0] ?? '사용자',
          realName: data['realName'] ?? data['name'] ?? currentUser.email?.split('@')[0] ?? '사용자',
          email: data['email'] ?? currentUser.email ?? '',
          gender: data['gender'],
          job: data['job'],
        );
        debugPrint('[UserController] Firestore 사용자 정보 업데이트 완료');
      }
    } catch (e) {
      debugPrint('[UserController] Firestore 사용자 정보 로드 실패 (기본값 유지): $e');
    }
  }
}