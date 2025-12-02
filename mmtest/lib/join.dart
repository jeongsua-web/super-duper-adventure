import 'package:flutter/material.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  String _selectedPhonePrefix = '010';
  String _selectedEmailDomain = 'naver.com';
  final TextEditingController _emailDomainController = TextEditingController();

  @override
  void dispose() {
    _emailDomainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 직접입력 선택시 UI 업데이트
    final isCustomDomain = _selectedEmailDomain == '직접입력';

    return Center(
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
                  Positioned(
                    left: 26,
                    top: 175,
                    child: Material(
                      child: SizedBox(
                        width: 90,
                        height: 29,
                        child: TextField(
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
                  Positioned(
                    left: 26,
                    top: 335,
                    child: Material(
                      child: SizedBox(
                        width: 170,
                        height: 29,
                        child: TextField(
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
                  Positioned(
                    left: 117,
                    top: 255,
                    child: Material(
                      child: SizedBox(
                        width: 70,
                        height: 29,
                        child: TextField(
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
                  Positioned(
                    left: 207,
                    top: 255,
                    child: Material(
                      child: SizedBox(
                        width: 70,
                        height: 29,
                        child: TextField(
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
                        child: DropdownButton<String>(
                          value: _selectedPhonePrefix,
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
                              setState(() {
                                _selectedPhonePrefix = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(left: 38, top: 260, child: SizedBox.shrink()),
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
                  Positioned(
                    left: 243,
                    top: 335,
                    child: Material(
                      child: isCustomDomain
                          ? SizedBox(
                              width: 104,
                              height: 29,
                              child: TextField(
                                controller: _emailDomainController,
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
                                    _selectedEmailDomain,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
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
                        child: DropdownButton<String>(
                          value: _selectedEmailDomain,
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
                              setState(() {
                                _selectedEmailDomain = newValue;
                                if (newValue == '직접입력') {
                                  _emailDomainController.clear();
                                } else {
                                  _emailDomainController.text = newValue;
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(left: 252, top: 339, child: SizedBox.shrink()),
                  Positioned(
                    left: 323,
                    top: 338,
                    child: Container(
                      width: 39,
                      height: 24,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Stack(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
