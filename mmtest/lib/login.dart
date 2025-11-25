class  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                                  fontWeight: FontWeight.w590,
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
                                        color: Colors.black /* Labels-Primary */,
                                      ),
                                      borderRadius: BorderRadius.circular(4.30),
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Gowun Dodum',
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Gowun Dodum',
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.80,
                  ),
                ),
              ),
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
                ),
              ),
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
                ),
              ),
              Positioned(
                left: 43,
                top: 431,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(side: BorderSide(width: 0.50)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 74,
                top: 719,
                child: Container(
                  width: 243,
                  height: 33,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFC4ECF6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 169,
                top: 498,
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
              Positioned(
                left: 161,
                top: 727,
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
              Positioned(
                left: 43,
                top: 584,
                child: Container(
                  width: 54,
                  height: 55,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/54x55"),
                      fit: BoxFit.fill,
                    ),
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFD3D3D3),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 168,
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
                left: 294,
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
                top: 472,
                child: Text(
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
              Positioned(
                left: 186,
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
              ),
              Positioned(
                left: 103,
                top: 113,
                child: SizedBox(
                  width: 179,
                  height: 123,
                  child: Text(
                    '마이',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFC4ECF6),
                      fontSize: 96,
                      fontFamily: 'Bagel Fat One',
                      fontWeight: FontWeight.w400,
                      height: 0.23,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 105,
                top: 205,
                child: SizedBox(
                  width: 179,
                  height: 123,
                  child: Text(
                    '마을',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFC4ECF6),
                      fontSize: 96,
                      fontFamily: 'Bagel Fat One',
                      fontWeight: FontWeight.w400,
                      height: 0.23,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}