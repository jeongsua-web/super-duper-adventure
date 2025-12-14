import 'package:get/get.dart';
import '../../../models/user.dart';

class UserController extends GetxController {
  // 반응형 변수: .obs를 붙여서 Rx 타입으로 선언
  final Rx<User?> _user = Rx<User?>(null);

  // Getter: .value로 실제 값에 접근
  User? get user => _user.value;

  // Setter: .value로 값을 업데이트하면 자동으로 UI가 반응
  void setUser(User user) {
    _user.value = user;
  }

  void clearUser() {
    _user.value = null;
  }

  // 선택적: user를 직접 Rx로 노출하려면 (Obx에서 사용)
  Rx<User?> get userRx => _user;
}