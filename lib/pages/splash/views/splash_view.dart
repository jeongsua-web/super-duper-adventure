import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4DDBFF), Color(0xFFC4ECF6)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 또는 아이콘
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_rounded,
                  size: 70,
                  color: Color(0xFF4DDBFF),
                ),
              ),
              const SizedBox(height: 40),
              
              // 앱 이름
              Text(
                '마이',
                style: GoogleFonts.bagelFatOne(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),
              Text(
                '마을',
                style: GoogleFonts.bagelFatOne(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 60),
              
              // 로딩 인디케이터
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
