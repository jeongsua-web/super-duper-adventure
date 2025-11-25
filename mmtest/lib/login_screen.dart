import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'join.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
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
                      spacing: 154,
                      children: [
                        Expanded(
                          child: Container(
                            height: 22,
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Text(
                                  '9:41',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black /* Labels-Primary */,
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
                        Expanded(
                          child: Container(
                            height: 22,
                            padding: const EdgeInsets.only(top: 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 7,
                              children: [
                                Opacity(
                                  opacity: 0.35,
                                  child: Container(
                                    width: 25,
                                    height: 13,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color:
                                              Colors.black /* Labels-Primary */,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          4.30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 21,
                                  height: 9,
                                  decoration: ShapeDecoration(
                                    color: Colors.black /* Labels-Primary */,
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
                Positioned(
                  left: 43,
                  top: 298,
                  child: Text(
                    '아이디',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                    ),
                  ),
                ),
                Positioned(
                  left: 43,
                  top: 371,
                  child: Text(
                    '비밀번호',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                    ),
                  ),
                ),
                Positioned(
                  left: 59,
                  top: 428,
                  child: Text(
                    '아이디/비밀번호 저장',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 1.80,
                    ),
                  ),
                ),
                Positioned(
                  left: 43,
                  top: 324,
                  child: Material(
                    child: SizedBox(
                      width: 306,
                      height: 29,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE7E7E7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 43,
                  top: 397,
                  child: Material(
                    child: SizedBox(
                      width: 306,
                      height: 29,
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE7E7E7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 43,
                  top: 431,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 74,
                  top: 490,
                  child: Container(
                    width: 243,
                    height: 33,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFC4ECF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 74,
                  top: 719,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JoinScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 243,
                      height: 33,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFC4ECF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 169,
                  top: 498,
                  child: Text(
                    '로그인',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 0.90,
                    ),
                  ),
                ),
                Positioned(
                  left: 161,
                  top: 727,
                  child: Text(
                    '회원가입',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 0.90,
                    ),
                  ),
                ),
                Positioned(
                  left: 98,
                  top: 584,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/55x55"),
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
                ),
                Positioned(
                  left: 237,
                  top: 584,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/55x55"),
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
                ),
                Positioned(
                  left: 147,
                  top: 467,
                  child: Text(
                    '아이디/비밀번호 찾기',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 1.64,
                    ),
                  ),
                ),
                Positioned(
                  left: 182,
                  top: 555,
                  child: Text(
                    '또는',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.29,
                    ),
                  ),
                ),
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
                Positioned(
                  left: 126,
                  top: 695,
                  child: Text(
                    '아직 계정이 없으신가요?',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.29,
                    ),
                  ),
                ),
                Positioned(
                  left: 103,
                  top: 143,
                  child: SizedBox(
                    width: 179,
                    height: 123,
                    child: Stack(
                      children: [
                        // 테두리 (뒤)
                        Text(
                          '마이',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bagelFatOne(
                            fontSize: 96,
                            fontWeight: FontWeight.w400,
                            height: 0.23,
                            letterSpacing: 1,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Colors.black,
                          ),
                        ),
                        // 그라데이션 채우기 (앞)
                        Text(
                          '마이',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bagelFatOne(
                            fontSize: 96,
                            fontWeight: FontWeight.w400,
                            height: 0.23,
                            letterSpacing: 1,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                colors: [Color(0xFFC4ECF6), Color(0xFFC4ECF6)],
                              ).createShader(Rect.fromLTWH(0, 0, 179, 123)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 105,
                  top: 235,
                  child: SizedBox(
                    width: 179,
                    height: 123,
                    child: Stack(
                      children: [
                        // 테두리 (뒤)
                        Text(
                          '마을',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bagelFatOne(
                            fontSize: 96,
                            fontWeight: FontWeight.w400,
                            height: 0.23,
                            letterSpacing: 1,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Colors.black,
                          ),
                        ),
                        // 그라데이션 채우기 (앞)
                        Text(
                          '마을',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bagelFatOne(
                            fontSize: 96,
                            fontWeight: FontWeight.w400,
                            height: 0.23,
                            letterSpacing: 1,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFC4ECF6), Color(0xFFB8E6A3)],
                              ).createShader(Rect.fromLTWH(0, 0, 179, 123)),
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
      ),
    );
  }
}
