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
                // 뒤로가기 버튼
                Positioned(
                  left: 25,
                  top: 62,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 27,
                    ),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                  ),
                ),
                // 회원가입 제목
                const Positioned(
                  left: 160,
                  top: 66,
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
                // 필수 입력란 안내
                Positioned(
                  left: 26,
                  top: 114,
                  child: Row(
                    children: const [
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: 0.20,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
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
                    ],
                  ),
                ),
                // 이름 라벨
                Positioned(
                  left: 26,
                  top: 149,
                  child: Row(
                    children: const [
                      Text(
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
                      SizedBox(width: 8),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
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
                // 이름 입력 필드
                Positioned(
                  left: 26,
                  top: 175,
                  child: Container(
                    width: 170,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      controller: controller.nameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // 전화번호 라벨
                Positioned(
                  left: 25,
                  top: 218,
                  child: Row(
                    children: const [
                      Text(
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
                      SizedBox(width: 8),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
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
                // 전화번호 앞자리
                Positioned(
                  left: 26,
                  top: 244,
                  child: Container(
                    width: 65,
                    height: 29,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedPhonePrefix.value,
                          isDense: true,
                          items: ['010', '011', '016', '017', '018', '019'].map(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontFamily: 'Gowun Dodum',
                                      fontSize: 14,
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
                        ),
                      ),
                    ),
                  ),
                ),
                // 하이픈 1
                const Positioned(
                  left: 95,
                  top: 247,
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
                // 전화번호 중간자리
                Positioned(
                  left: 116,
                  top: 244,
                  child: Container(
                    width: 85,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      controller: controller.phone1Controller,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // 하이픈 2
                const Positioned(
                  left: 205,
                  top: 247,
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
                // 전화번호 끝자리
                Positioned(
                  left: 229,
                  top: 242,
                  child: Container(
                    width: 85,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      controller: controller.phone2Controller,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // 이메일 라벨
                Positioned(
                  left: 26,
                  top: 288,
                  child: Row(
                    children: const [
                      Text(
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
                      SizedBox(width: 8),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
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
                // 이메일 로컬 파트
                Positioned(
                  left: 26,
                  top: 314,
                  child: Container(
                    width: 170,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      controller: controller.emailLocalController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // @
                const Positioned(
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
                // 이메일 도메인 드롭다운
                Positioned(
                  left: 243,
                  top: 314,
                  child: Container(
                    width: 124,
                    height: 29,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedEmailDomain.value,
                          isDense: true,
                          items: ['naver.com', 'gmail.com', 'daum.net', '직접입력']
                              .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontFamily: 'Gowun Dodum',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.updateEmailDomain(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // 아이디 라벨
                Positioned(
                  left: 26,
                  top: 368,
                  child: Row(
                    children: const [
                      Text(
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
                      SizedBox(width: 8),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
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
                // 아이디 입력 필드
                Positioned(
                  left: 26,
                  top: 394,
                  child: Container(
                    width: 200,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      controller: controller.usernameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // 중복확인 버튼
                Positioned(
                  left: 265,
                  top: 394,
                  child: GestureDetector(
                    onTap: () {
                      Get.snackbar('중복확인', '준비 중입니다');
                    },
                    child: Container(
                      width: 88,
                      height: 29,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFF4CDBFF),
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Center(
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
                  ),
                ),
                // 비밀번호 라벨
                Positioned(
                  left: 26,
                  top: 445,
                  child: Row(
                    children: const [
                      Text(
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
                      SizedBox(width: 8),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: 0.20,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
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
                    ],
                  ),
                ),
                // 비밀번호 입력 필드
                Positioned(
                  left: 26,
                  top: 471,
                  child: Container(
                    width: 200,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // 비밀번호 확인 라벨
                Positioned(
                  left: 26,
                  top: 522,
                  child: Row(
                    children: const [
                      Text(
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
                      SizedBox(width: 8),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Color(0xFFFE4B4B),
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
                // 비밀번호 확인 입력 필드
                Positioned(
                  left: 26,
                  top: 548,
                  child: Container(
                    width: 200,
                    height: 29,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: TextField(
                      obscureText: true,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: -4,
                          bottom: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Gowun Dodum',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // 성별 라벨
                const Positioned(
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
                // 성별 체크박스들
                ..._buildGenderCheckboxes(),
                // 직업 라벨
                const Positioned(
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
                // 직업 체크박스들
                ..._buildJobCheckboxes(),
                // 회원가입 완료 버튼
                Positioned(
                  left: 130,
                  top: 810,
                  child: Obx(
                    () => GestureDetector(
                      onTap: controller.isLoading.value
                          ? null
                          : controller.handleSignup,
                      child: Container(
                        width: 133,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: controller.isLoading.value
                              ? const Color(0xFFE0E0E0)
                              : const Color(0xFFC4ECF6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Center(
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
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

  List<Widget> _buildGenderCheckboxes() {
    return [
      // 저는 남자에요
      _buildCheckboxWithTap(25, 638, '저는 남자에요'),
      const Positioned(
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
      // 저는 여자에요
      _buildCheckboxWithTap(125, 638, '저는 여자에요'),
      const Positioned(
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
      // 아직 잘 모르겠는데요
      _buildCheckboxWithTap(25, 658, '아직 잘 모르겠는데요'),
      const Positioned(
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
      // 중성이에요
      _buildCheckboxWithTap(162, 658, '중성이에요'),
      const Positioned(
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
    ];
  }

  List<Widget> _buildJobCheckboxes() {
    return [
      // 할 일 없는 백수
      _buildJobCheckboxWithTap(25, 719, '할 일 없는 백수'),
      const Positioned(
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
      // 바쁜 직장인
      _buildJobCheckboxWithTap(130, 719, '바쁜 직장인'),
      const Positioned(
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
      // 시험이 싫은 학생
      _buildJobCheckboxWithTap(216, 719, '시험이 싫은 학생'),
      const Positioned(
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
      // 겨울양식 준비하는 다람쥐
      _buildJobCheckboxWithTap(25, 739, '겨울양식 준비하는 다람쥐'),
      const Positioned(
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
      // 물로 인해 숨막히는 물고기
      _buildJobCheckboxWithTap(182, 739, '물로 인해 숨막히는 물고기'),
      const Positioned(
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
      // 직접입력 체크박스
      Positioned(
        left: 25,
        top: 762,
        child: GestureDetector(
          onTap: () => controller.selectJob('직접입력'),
          child: Obx(
            () => Container(
              width: 13,
              height: 13,
              decoration: ShapeDecoration(
                color: controller.selectedJob.value == '직접입력'
                    ? const Color(0xFFC4ECF6)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF4CDBFF)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: controller.selectedJob.value == '직접입력'
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
      // 직접입력 배경 및 입력 필드
      Positioned(
        left: 45,
        top: 759,
        child: GestureDetector(
          onTap: () => controller.selectJob('직접입력'),
          child: Container(
            width: 250,
            height: 20,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF4CDBFF)),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            alignment: Alignment.center,
            child: Obx(
              () => TextField(
                controller: controller.customJobController,
                enabled: controller.selectedJob.value == '직접입력',
                textAlignVertical: TextAlignVertical.center,
                onTap: () {
                  if (controller.selectedJob.value != '직접입력') {
                    controller.selectJob('직접입력');
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '직접입력',
                  hintStyle: TextStyle(
                    fontFamily: 'Gowun Dodum',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: -4,
                    bottom: 4,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontFamily: 'Gowun Dodum',
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildCheckboxWithTap(double left, double top, String genderValue) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => controller.selectGender(genderValue),
        child: Obx(
          () => Container(
            width: 13,
            height: 13,
            decoration: ShapeDecoration(
              color: controller.selectedGender.value == genderValue
                  ? const Color(0xFFC4ECF6)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF4CDBFF)),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: controller.selectedGender.value == genderValue
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCheckboxWithTap(double left, double top, String jobValue) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => controller.selectJob(jobValue),
        child: Obx(
          () => Container(
            width: 13,
            height: 13,
            decoration: ShapeDecoration(
              color: controller.selectedJob.value == jobValue
                  ? const Color(0xFFC4ECF6)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF4CDBFF)),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: controller.selectedJob.value == jobValue
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }

  static Widget _buildCheckbox(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 13,
        height: 13,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
