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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                      left: 160,
                      top: 66,
                      child: SizedBox(
                        width: 73,
                        height: 27,
                        child: Text(
                          '회원가입',
                          maxLines: 1,
                          softWrap: false,
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
                      child: SizedBox(
                        width: 162,
                        height: 23,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 16,
                              top: 0,
                              child: Text(
                                '표시는 필수 입력란 입니다.',
                                maxLines: 1,
                                softWrap: false,
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
                                maxLines: 1,
                                softWrap: false,
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
                        maxLines: 1,
                        softWrap: false,
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
                      left: 92,
                      top: 227,
                      child: Text(
                        '*',
                        maxLines: 1,
                        softWrap: false,
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
                      top: 308,
                      child: Text(
                        '*',
                        maxLines: 1,
                        softWrap: false,
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
                        maxLines: 1,
                        softWrap: false,
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
                      top: 229,
                      child: Text(
                        '전화번호',
                        maxLines: 1,
                        softWrap: false,
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
                      top: 309,
                      child: Text(
                        '이메일',
                        maxLines: 1,
                        softWrap: false,
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
                    // 이름 입력 필드
                    Positioned(
                      left: 26,
                      top: 175,
                      child: Material(
                        child: SizedBox(
                          width: 90,
                          height: 29,
                          child: TextField(
                            controller: controller.nameController,
                            enabled: true,
                            enableInteractiveSelection: true,
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
                    // 이메일 로컬 파트 입력 필드
                    Positioned(
                      left: 26,
                      top: 335,
                      child: Material(
                        child: SizedBox(
                          width: 170,
                          height: 29,
                          child: TextField(
                            controller: controller.emailLocalController,
                            enabled: true,
                            enableInteractiveSelection: true,
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
                    // 전화번호 중간자리
                    Positioned(
                      left: 117,
                      top: 255,
                      child: Material(
                        child: SizedBox(
                          width: 70,
                          height: 29,
                          child: TextField(
                            controller: controller.phone1Controller,
                            enabled: true,
                            enableInteractiveSelection: true,
                            keyboardType: TextInputType.number,
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
                    // 전화번호 끝자리
                    Positioned(
                      left: 207,
                      top: 255,
                      child: Material(
                        child: SizedBox(
                          width: 70,
                          height: 29,
                          child: TextField(
                            controller: controller.phone2Controller,
                            enabled: true,
                            enableInteractiveSelection: true,
                            keyboardType: TextInputType.number,
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
                    // 전화번호 앞자리 드롭다운
                    Positioned(
                      left: 26,
                      top: 255,
                      child: Material(
                        child: Container(
                          width: 75,
                          height: 29,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.70),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Obx(() => DropdownButton<String>(
                            value: controller.selectedPhonePrefix.value,
                            isExpanded: false,
                            underline: SizedBox(),
                            items: ['010', '011', '016', '017', '018', '019'].map(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Gowun Dodum',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.updatePhonePrefix(newValue);
                              }
                            },
                          )),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 107,
                      top: 258,
                      child: Text(
                        '-',
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
                      left: 194,
                      top: 258,
                      child: Text(
                        '-',
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
                      left: 208,
                      top: 340,
                      child: Text(
                        '@',
                        maxLines: 1,
                        softWrap: false,
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
                    // 이메일 도메인 표시/입력 영역
                    Positioned(
                      left: 243,
                      top: 335,
                      child: Material(
                        child: Obx(() {
                          final isCustomDomain = controller.selectedEmailDomain.value == '직접입력';
                          return isCustomDomain
                              ? SizedBox(
                                  width: 104,
                                  height: 29,
                                  child: TextField(
                                    controller: controller.emailDomainController,
                                    enabled: true,
                                    enableInteractiveSelection: true,
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
                                )
                              : Container(
                                  width: 104,
                                  height: 29,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE7E7E7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        controller.selectedEmailDomain.value,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Gowun Dodum',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        }),
                      ),
                    ),
                    // 이메일 도메인 드롭다운
                    Positioned(
                      left: 243,
                      top: 370,
                      child: Material(
                        child: Container(
                          width: 104,
                          height: 29,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.70),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: Obx(() => DropdownButton<String>(
                            value: controller.selectedEmailDomain.value,
                            isDense: true,
                            isExpanded: false,
                            underline: SizedBox(),
                            items: const <DropdownMenuItem<String>>[
                              DropdownMenuItem<String>(
                                value: 'naver.com',
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'naver.com',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'gmail.com',
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'gmail.com',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: 'daum.net',
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'daum.net',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: '직접입력',
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '직접입력',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.updateEmailDomain(newValue);
                              }
                            },
                          )),
                        ),
                      ),
                    ),
                    // 비밀번호 라벨
                    Positioned(
                      left: 26,
                      top: 420,
                      child: Row(
                        children: [
                          Text(
                            '비밀번호',
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                              height: 1.11,
                              letterSpacing: 0.18,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '*',
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: const Color(0xFFFE4B4B),
                              fontSize: 20,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                              height: 1,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 비밀번호 입력 필드
                    Positioned(
                      left: 26,
                      top: 450,
                      child: Material(
                        child: SizedBox(
                          width: 200,
                          height: 29,
                          child: TextField(
                            controller: controller.passwordController,
                            enabled: true,
                            enableInteractiveSelection: true,
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
                    // 회원가입 완료 버튼
                    Positioned(
                      left: 130,
                      top: 750,
                      child: Obx(() => GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.handleSignup,
                        child: Container(
                          width: 133,
                          height: 40,
                          decoration: ShapeDecoration(
                            color: controller.isLoading.value 
                                ? const Color(0xFFE0E0E0) 
                                : const Color(0xFFFFA9A9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  )
                                : Text(
                                    '회원가입 완료',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ),
                        ),
                      )),
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
