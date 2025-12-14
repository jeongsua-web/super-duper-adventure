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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 1.00),
            end: Alignment(0.50, 0.00),
            colors: [Color(0xFFC4ECF6), Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // 중앙 상단 - "마이" 텍스트
            Positioned(
              left: 106,
              top: 211,
              child: SizedBox(
                width: 179,
                height: 123,
                child: Text(
                  '마이',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bagelFatOne(
                    color: const Color(0xFFC4ECF6),
                    fontSize: 96,
                    fontWeight: FontWeight.w400,
                    height: 0.23,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            
            // 중앙 하단 - "마을" 텍스트
            Positioned(
              left: 108,
              top: 303,
              child: SizedBox(
                width: 179,
                height: 123,
                child: Text(
                  '마을',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bagelFatOne(
                    color: const Color(0xFFC4ECF6),
                    fontSize: 96,
                    fontWeight: FontWeight.w400,
                    height: 0.23,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            
            // 중앙 하단 - 마을 아이콘
            Positioned(
              left: 116,
              top: 710,
              child: Container(
                width: 162,
                height: 147,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Image.asset(
                  'assets/images/village.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // 왼쪽 하단 - 집 아이콘 (회전)
            Positioned(
              left: -4.76,
              top: 760.96,
              child: Transform.rotate(
                angle: -0.45,
                child: Container(
                  width: 92,
                  height: 92,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/images/house.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            
            // 오른쪽 하단 - 우체통 아이콘 (회전)
            Positioned(
              left: 314.43,
              top: 701,
              child: Transform.rotate(
                angle: 0.40,
                child: Container(
                  width: 81,
                  height: 81,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/images/mailBox.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
