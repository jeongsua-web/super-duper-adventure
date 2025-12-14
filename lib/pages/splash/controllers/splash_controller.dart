import 'dart:async'; // Timer 사용을 위해 필요
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  // late로 지연 초기화
  late final UserController _userController;

  @override
  void onInit() {
    super.onInit();
    // onInit에서 UserController 찾기
    _userController = Get.find<UserController>();
    print('[SplashController] onInit - UserController 찾음');
  }

  @override
  void onReady() {
    super.onReady();
    print('[SplashController] onReady 호출됨');
    _handleStartUpLogic();
  }

  Future<void> _handleStartUpLogic() async {
    print('[Splash] 앱 시작 로직 실행');

    // 1. 로고 보여주기 (최소 1.5초 대기)
    await Future.delayed(const Duration(milliseconds: 1500));

    // 2. [비상 탈출] 무한 로딩 방지용 타이머
    // 0.2초마다 검사해서 isAutoLoginChecked가 true면 이동
    // 최대 5초(25번)까지만 기다림
    int retryCount = 0;
    
    while (!_userController.isAutoLoginChecked.value) {
      if (retryCount >= 25) { 
        print('[Splash] ⚠️ 시간 초과! (5초 경과) -> 강제로 이동합니다.');
        break; // 루프 탈출
      }
      
      print('[Splash] 아직 로딩 중... (${retryCount + 1}/25)');
      await Future.delayed(const Duration(milliseconds: 200)); // 0.2초 대기
      retryCount++;
    }

    // 3. 루프 탈출 후 이동 (성공이든 실패든 무조건 이동)
    print('[Splash] 로딩 종료 -> 화면 이동');
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    if (_userController.user != null) {
      print('[Splash] 로그인 상태 O -> 메인으로');
      Get.offAllNamed(AppRoutes.mainHome);
    } else {
      print('[Splash] 로그인 상태 X -> 로그인 화면으로');
      Get.offAllNamed(AppRoutes.login);
    }
  }
}