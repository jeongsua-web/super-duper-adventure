import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../services/storage_service.dart';

class SplashController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // 스플래시 화면 최소 표시 시간 (UX)
    await Future.delayed(const Duration(seconds: 2));

    // 토큰 확인
    final token = _storage.readString('uToken');
    
    if (token == null || token.isEmpty) {
      // 토큰 없음 - 로그인 화면으로
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // 자동 로그인 완료 대기 (최대 3초)
    int waitCount = 0;
    while (waitCount < 30 && _userController.user == null) {
      await Future.delayed(const Duration(milliseconds: 100));
      waitCount++;
    }

    // 로그인 상태 확인
    if (_userController.user != null) {
      // 자동 로그인 성공 - 메인 홈으로
      Get.offAllNamed(AppRoutes.mainHome);
    } else {
      // 자동 로그인 실패 - 로그인 화면으로
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
