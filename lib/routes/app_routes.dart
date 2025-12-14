import 'package:get/get.dart';
import 'package:my_app/pages/splash/views/splash_view.dart';
import 'package:my_app/pages/splash/controllers/splash_controller.dart';
import 'package:my_app/pages/auth/views/login_view.dart';
import 'package:my_app/pages/auth/controllers/login_controller.dart';
import 'package:my_app/pages/auth/views/signup_view.dart';
import 'package:my_app/pages/auth/controllers/signup_controller.dart';
import 'package:my_app/pages/home/views/main_home_view.dart';
import 'package:my_app/pages/home/controllers/main_home_controller.dart';
import 'package:my_app/pages/home/views/home_view.dart';
import 'package:my_app/pages/home/controllers/home_controller.dart';
import 'package:my_app/pages/settings/views/account_settings_view.dart';
import 'package:my_app/pages/settings/controllers/account_settings_controller.dart';
import 'package:my_app/pages/mailbox/views/mailbox_view.dart';
import 'package:my_app/pages/mailbox/controllers/mailbox_controller.dart';
import 'package:my_app/pages/village/views/village_dashboard_view.dart';
import 'package:my_app/pages/village/controllers/village_view_controller.dart';
import 'package:my_app/pages/village/views/tilemap_view.dart';
import 'package:my_app/pages/village/controllers/tilemap_controller.dart';
import 'package:my_app/pages/community/views/board_view.dart';
import 'package:my_app/pages/community/controllers/board_controller.dart';
import 'package:my_app/pages/community/views/board_list_view.dart';
import 'package:my_app/pages/community/controllers/board_list_controller.dart';
import 'package:my_app/pages/community/views/quiz_view.dart';
import 'package:my_app/pages/community/controllers/quiz_controller.dart';
import 'package:my_app/pages/village/views/village_settings_view.dart';
import 'package:my_app/pages/village/controllers/village_settings_controller.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String mainHome = '/main-home';
  static const String village = '/village';
  static const String villageCreate = '/village-create';
  static const String tilemap = '/tilemap';
  static const String board = '/board';
  static const String boardList = '/board-list';
  static const String quiz = '/quiz';
  static const String mailbox = '/mailbox';
  static const String settings = '/settings';
  static const String villageSettings = '/village-settings';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignupController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.mainHome,
      page: () => const MainHomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MainHomeController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.village,
      page: () => const VillageDashboardView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String?;
        final villageId = args['villageId'] as String?;
        Get.lazyPut(() => VillageViewController(
          villageName: villageName,
          villageId: villageId,
        ));
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.tilemap,
      page: () => const TileMapView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String?;
        Get.lazyPut(() => TileMapController(
          villageName: villageName,
          villageId: villageId,
        ));
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.board,
      page: () => const BoardView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        Get.lazyPut(() => BoardController(
          villageName: villageName,
          villageId: villageId,
        ));
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.boardList,
      page: () => const BoardListView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final category = args['category'] as String? ?? '전체';
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        Get.lazyPut(() => BoardListController(
          category: category,
          villageName: villageName,
          villageId: villageId,
        ));
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        Get.lazyPut(() => QuizController(
          villageName: villageName,
          villageId: villageId,
        ));
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mailbox,
      page: () => const MailboxView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MailboxController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const AccountSettingsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AccountSettingsController());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.villageSettings,
      page: () => const VillageSettingsView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageId = args['villageId'] as String? ?? '';
        final villageName = args['villageName'] as String? ?? '마을';
        Get.lazyPut(() => VillageSettingsController(
          villageId: villageId,
          villageName: villageName,
        ));
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}
