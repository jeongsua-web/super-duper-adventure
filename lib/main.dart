import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'pages/auth/views/login_view.dart';
import 'pages/home/views/main_home_view.dart';
import 'pages/user/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // GetX 컨트롤러 의존성 주입
  Get.put(UserController());

  // 초기 경로 결정
  String initialRoute = AppRoutes.login;
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    initialRoute = AppRoutes.mainHome;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '우리 마을',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        textTheme: GoogleFonts.gowunDodumTextTheme(),
      ),
      getPages: AppPages.pages,
      initialRoute: initialRoute,
    );
  }
}
