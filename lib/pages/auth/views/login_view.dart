import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Stack(
            children: [
              // Logo
              Positioned(
                left: 50,
                top: 100,
                child: SizedBox(
                  width: 293,
                  height: 250,
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Email label
              const Positioned(
                left: 43,
                top: 298,
                child: Text(
                  '이메일',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.38,
                  ),
                ),
              ),

              // Email input field
              Positioned(
                left: 43,
                top: 324,
                child: Container(
                  width: 306,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE7E7E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),

              // Password label
              const Positioned(
                left: 43,
                top: 385,
                child: Text(
                  '비밀번호',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.38,
                  ),
                ),
              ),

              // Password input field
              Positioned(
                left: 43,
                top: 411,
                child: Container(
                  width: 306,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE7E7E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),

              // Save checkbox - Obx로 감싸서 반응형
              Positioned(
                left: 43,
                top: 469,
                child: Obx(
                  () => GestureDetector(
                    onTap: controller.toggleSavePassword,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: ShapeDecoration(
                        color: controller.savePassword.value
                            ? const Color(0xFFC4ECF6)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Save password text
              const Positioned(
                left: 59,
                top: 466,
                child: Text(
                  '아이디/비밀번호 저장',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.80,
                  ),
                ),
              ),

              // Find ID/Password link
              Positioned(
                left: 147,
                top: 507,
                child: GestureDetector(
                  onTap: controller.handleFindAccount,
                  child: const Text(
                    '아이디/비밀번호 찾기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                      height: 1.64,
                    ),
                  ),
                ),
              ),

              // Login button - Obx로 로딩 상태 처리
              Positioned(
                left: 74,
                top: 530,
                child: Obx(
                  () => GestureDetector(
                    onTap: controller.isLoading.value
                        ? null
                        : controller.handleLogin,
                    child: Container(
                      width: 243,
                      height: 33,
                      decoration: ShapeDecoration(
                        color: controller.isLoading.value
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              )
                            : const Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 0.90,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              // "또는" text
              const Positioned(
                left: 182,
                top: 595,
                child: Text(
                  '또는',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
              ),

              // Social login button 1 (Google)
              Positioned(
                left: 98,
                top: 624,
                child: GestureDetector(
                  onTap: controller.handleGoogleSignIn,
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/google.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Social login button 2 (Apple)
              Positioned(
                left: 237,
                top: 624,
                child: GestureDetector(
                  onTap: controller.handleAppleSignIn,
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/apple.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Apple',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider line
              Positioned(
                left: 43,
                top: 713,
                child: Container(
                  width: 306,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFAFAFAF),
                      ),
                    ),
                  ),
                ),
              ),

              // "아직 계정이 없으신가요?" text
              const Positioned(
                left: 126,
                top: 743,
                child: Text(
                  '아직 계정이 없으신가요?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
              ),

              // Sign up button
              Positioned(
                left: 74,
                top: 767,
                child: GestureDetector(
                  onTap: controller.navigateToSignUp,
                  child: Container(
                    width: 243,
                    height: 33,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFC4ECF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          height: 0.90,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Add height to make container tall enough
              const Positioned(
                left: 0,
                top: 852,
                child: SizedBox(width: 1, height: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
