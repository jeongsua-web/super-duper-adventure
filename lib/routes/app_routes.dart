import 'package:get/get.dart';
import 'package:my_app/screens/auth/login_screen.dart';
import 'package:my_app/screens/main_home_screen.dart';
import 'package:my_app/screens/village/village_view_screen.dart';
import 'package:my_app/screens/community/board_screen.dart';
import 'package:my_app/screens/community/board_list_screen.dart';
import 'package:my_app/screens/community/quiz_screen.dart';
import 'package:my_app/screens/mailbox_screen.dart';
import 'package:my_app/screens/settings/account_settings_screen.dart';
import 'package:my_app/screens/home_screen.dart';

abstract class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String mainHome = '/main-home';
  static const String village = '/village';
  static const String board = '/board';
  static const String boardList = '/board-list';
  static const String quiz = '/quiz';
  static const String mailbox = '/mailbox';
  static const String settings = '/settings';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.mainHome,
      page: () => const MainHomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.village,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        return VillageViewScreen(
          villageName: villageName,
          villageId: villageId,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.board,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        return BoardScreen(
          villageName: villageName,
          villageId: villageId,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.boardList,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final category = args['category'] as String? ?? '전체';
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        return BoardListScreen(
          category: category,
          villageName: villageName,
          villageId: villageId,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        final villageName = args['villageName'] as String? ?? '마을';
        final villageId = args['villageId'] as String? ?? '';
        return QuizScreen(
          villageName: villageName,
          villageId: villageId,
        );
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mailbox,
      page: () => const MailboxScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const AccountSettingsScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
