import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'auth/signup_screen.dart';
import 'main_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _idController;
  late TextEditingController _passwordController;
  bool _savePassword = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _idController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 입력하세요')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainHomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = '존재하지 않는 계정입니다';
      } else if (e.code == 'wrong-password') {
        message = '비밀번호가 틀렸습니다';
      } else if (e.code == 'invalid-email') {
        message = '이메일 형식이 올바르지 않습니다';
      } else if (e.code == 'invalid-credential') {
        message = '이메일 또는 비밀번호가 올바르지 않습니다';
      } else {
        message = '로그인 실패: ${e.message}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류 발생: $e')),
        );
      }
    }
  }

  void _handleSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      if (kIsWeb) {
        // Web에서는 signInWithPopup 사용
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // 모바일에서는 Google Sign-In 패키지 사용
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google 로그인 성공!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainHomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        print('Google 로그인 에러: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google 로그인 실패: $e')),
        );
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    try {
      if (kIsWeb) {
        // Web에서는 signInWithPopup 사용
        OAuthProvider appleProvider = OAuthProvider('apple.com');
        appleProvider.addScope('email');
        appleProvider.addScope('name');
        await FirebaseAuth.instance.signInWithPopup(appleProvider);
      } else {
        // 모바일에서는 Sign In with Apple 패키지 사용
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oauthCredential = OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apple 로그인 성공!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainHomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        print('Apple 로그인 에러: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple 로그인 실패: $e')),
        );
      }
    }
  }

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
              // Status bar notch
              Positioned(
                left: 129,
                top: 16,
                child: Container(
                  width: 131,
                  height: 33,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF383838),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),

              // Status bar
              Positioned(
                left: -4,
                top: 2,
                child: Container(
                  width: 402,
                  padding: const EdgeInsets.only(
                    top: 21,
                    left: 16,
                    right: 16,
                    bottom: 19,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 22,
                          padding: const EdgeInsets.only(top: 2),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '9:41',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                  height: 1.29,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 154),
                      Expanded(
                        child: Container(
                          height: 22,
                          padding: const EdgeInsets.only(top: 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 0.35,
                                child: Container(
                                  width: 25,
                                  height: 13,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(4.30),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Container(
                                width: 21,
                                height: 9,
                                decoration: ShapeDecoration(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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

              // Logo "마을" - 이미지로 대체되어 주석 처리
              // Positioned(
              //   left: 105,
              //   top: 205,
              //   child: SizedBox(
              //     width: 179,
              //     height: 123,
              //     child: Text(
              //       '마을',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         color: const Color(0xFFC4ECF6),
              //         fontSize: 96,
              //         fontFamily: 'Bagel Fat One',
              //         fontWeight: FontWeight.w400,
              //         height: 0.23,
              //         letterSpacing: 1,
              //       ),
              //     ),
              //   ),
              // ),

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
                  height: 29,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE7E7E7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  ),
                  child: TextField(
                    controller: _idController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),

              // Password label
              const Positioned(
                left: 43,
                top: 371,
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
                top: 397,
                child: Container(
                  width: 306,
                  height: 29,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE7E7E7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),

              // Save checkbox
              Positioned(
                left: 43,
                top: 431,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _savePassword = !_savePassword;
                    });
                  },
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: ShapeDecoration(
                      color: _savePassword ? const Color(0xFFC4ECF6) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.50),
                      ),
                    ),
                  ),
                ),
              ),

              // Save password text
              const Positioned(
                left: 59,
                top: 428,
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
                top: 472,
                child: GestureDetector(
                  onTap: () {
                    // Handle find ID/password
                  },
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

              // Login button
              Positioned(
                left: 74,
                top: 490,
                child: GestureDetector(
                  onTap: _handleLogin,
                  child: Container(
                    width: 243,
                    height: 33,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFC4ECF6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
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

              // "또는" text
              const Positioned(
                left: 182,
                top: 555,
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
                top: 584,
                child: GestureDetector(
                  onTap: _handleGoogleSignIn,
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/55x55"),
                            fit: BoxFit.cover,
                          ),
                          shape: OvalBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFC5C5C5),
                            ),
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
                top: 584,
                child: GestureDetector(
                  onTap: _handleAppleSignIn,
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage("https://via.placeholder.com/55x55"),
                            fit: BoxFit.cover,
                          ),
                          shape: OvalBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFC5C5C5),
                            ),
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
                top: 657,
                child: Container(
                  width: 306,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xFFAFAFAF),
                      ),
                    ),
                  ),
                ),
              ),

              // "아직 계정이 없으신가요?" text
              const Positioned(
                left: 126,
                top: 695,
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
                top: 719,
                child: GestureDetector(
                  onTap: _handleSignUp,
                  child: Container(
                    width: 243,
                    height: 33,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFC4ECF6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
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