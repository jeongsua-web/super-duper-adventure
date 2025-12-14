import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 393,
                height: 871,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 393,
                        height: 871,
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
                              left: 160,
                              top: 66,
                              child: SizedBox(
                                width: 73,
                                height: 27,
                                child: Text(
                                  '회원가입',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: 0.20,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 114,
                              child: Container(
                                width: 162,
                                height: 23,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 16,
                                      top: 0,
                                      child: Text(
                                        '표시는 필수 입력란 입니다.',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontFamily: 'Gowun Dodum',
                                          fontWeight: FontWeight.w400,
                                          height: 1.54,
                                          letterSpacing: 0.13,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 3,
                                      child: Text(
                                        '*',
                                        style: TextStyle(
                                          color: const Color(0xFFFE4B4B),
                                          fontSize: 20,
                                          fontFamily: 'Gowun Dodum',
                                          fontWeight: FontWeight.w400,
                                          height: 1,
                                          letterSpacing: 0.20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 60,
                              top: 149,
                              child: Text(
                                '*',
                                style: TextStyle(
                                  color: const Color(0xFFFE4B4B),
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 91,
                              top: 216,
                              child: Text(
                                '*',
                                style: TextStyle(
                                  color: const Color(0xFFFE4B4B),
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 74,
                              top: 287,
                              child: Text(
                                '*',
                                style: TextStyle(
                                  color: const Color(0xFFFE4B4B),
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 74,
                              top: 368,
                              child: Text(
                                '*',
                                style: TextStyle(
                                  color: const Color(0xFFFE4B4B),
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 90,
                              top: 446,
                              child: Text(
                                '*',
                                style: TextStyle(
                                  color: const Color(0xFFFE4B4B),
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 129,
                              top: 520,
                              child: Text(
                                '*',
                                style: TextStyle(
                                  color: const Color(0xFFFE4B4B),
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 149,
                              child: Text(
                                '이름',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 218,
                              child: Text(
                                '전화번호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 288,
                              child: Text(
                                '이메일',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 368,
                              child: Text(
                                '아이디',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 608,
                              child: Text(
                                '성별',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 689,
                              child: Text(
                                '직업',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 445,
                              child: Text(
                                '비밀번호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 522,
                              child: Text(
                                '비밀번호 확인',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: 0.18,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 175,
                              child: Container(
                                width: 170,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 394,
                              child: Container(
                                width: 200,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 471,
                              child: Container(
                                width: 200,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 548,
                              child: Container(
                                width: 200,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 95,
                              top: 763,
                              child: Container(
                                width: 200,
                                height: 13,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 314,
                              child: Container(
                                width: 170,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 116,
                              top: 244,
                              child: Container(
                                width: 85,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 26,
                              top: 244,
                              child: Container(
                                width: 65,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 229,
                              top: 242,
                              child: Container(
                                width: 85,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFE7E7E7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 208,
                              top: 319,
                              child: Text(
                                '@',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 243,
                              top: 314,
                              child: Container(
                                width: 124,
                                height: 29,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 0.70),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 252,
                              top: 318,
                              child: SizedBox(
                                width: 77,
                                height: 18,
                                child: Text(
                                  'naver.com',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w400,
                                    height: 1.25,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 265,
                              top: 398,
                              child: Container(
                                width: 88,
                                height: 21,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 0.50),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 280,
                              top: 398,
                              child: SizedBox(
                                width: 64,
                                height: 20,
                                child: Text(
                                  '중복확인',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Gowun Dodum',
                                    fontWeight: FontWeight.w400,
                                    height: 1.25,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 109,
                              top: 446,
                              child: Text(
                                '영문, 숫자, 특수기호 조합',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 2.50,
                                  letterSpacing: 0.08,
                                ),
                              ),
                            ),
                            // Gender checkboxes
                            Positioned(
                              left: 25,
                              top: 638,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 658,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 125,
                              top: 638,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 162,
                              top: 658,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            // Job checkboxes
                            Positioned(
                              left: 25,
                              top: 719,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 130,
                              top: 719,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 216,
                              top: 719,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 739,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 182,
                              top: 739,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 763,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            // Gender labels
                            Positioned(
                              left: 45,
                              top: 634,
                              child: Text(
                                '저는 남자에요',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 45,
                              top: 654,
                              child: Text(
                                '아직 잘 모르겠는데요',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 145,
                              top: 634,
                              child: Text(
                                '저는 여자에요',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 182,
                              top: 654,
                              child: Text(
                                '중성이에요',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            // Job labels
                            Positioned(
                              left: 45,
                              top: 715,
                              child: Text(
                                '할 일 없는 백수',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 150,
                              top: 715,
                              child: Text(
                                '바쁜 직장인',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 236,
                              top: 715,
                              child: Text(
                                '시험이 싫은 학생',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 45,
                              top: 735,
                              child: Text(
                                '겨울양식 준비하는 다람쥐',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 202,
                              top: 735,
                              child: Text(
                                '물로 인해 숨막히는 물고기',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 45,
                              top: 759,
                              child: Text(
                                '직접입력',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Gowun Dodum',
                                  fontWeight: FontWeight.w400,
                                  height: 1.67,
                                  letterSpacing: 0.12,
                                ),
                              ),
                            ),
                            // Back button
                            Positioned(
                              left: 25,
                              top: 62,
                              child: Container(
                                width: 31,
                                height: 27,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.black),
                                  onPressed: () => Get.back(),
                                  padding: EdgeInsets.zero,
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
            ],
          ),
        ),
      ),
    );
  }
}
