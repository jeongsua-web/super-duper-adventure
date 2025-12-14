import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 1.00),
            end: Alignment(0.50, -0.00),
            colors: [Color(0xFFC4ECF6), Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // 로고
            Positioned(
              left: 96.w,
              top: 250.h,
              child: SizedBox(
                width: 200.w,
                height: 200.h,
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // 하트 아이콘
            Positioned(
              left: 260.w,
              top: 260.h,
              child: SizedBox(
                width: 40.w,
                height: 40.h,
                child: Image.asset(
                  'assets/images/heart.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // 큰 하트 아이콘 (오른쪽 대각선 위)
            Positioned(
              left: 280.w,
              top: 200.h,
              child: SizedBox(
                width: 60.w,
                height: 60.h,
                child: Image.asset(
                  'assets/images/heart.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // 로딩 인디케이터
            Positioned(
              left: 0,
              right: 0,
              top: 460.h,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFC4ECF6),
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100.w,
              top: 550.h,
              child: Container(
                width: 130.w,
                height: 120.h,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: Image.asset(
                  'assets/images/boy1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              left: 20.w,
              top: 700.h,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0)
                  ..rotateZ(-0.45),
                child: Container(
                  width: 92.w,
                  height: 92.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/images/boy2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 280.w,
              top: 640.h,
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0)
                  ..rotateZ(0.40),
                child: Container(
                  width: 81.w,
                  height: 81.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    'assets/images/girl.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // 하단 집 아이콘
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.asset(
                    'assets/images/house.png',
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
