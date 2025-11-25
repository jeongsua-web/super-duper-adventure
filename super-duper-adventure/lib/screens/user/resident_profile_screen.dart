import 'package:flutter/material.dart';

class ResidentProfileScreen extends StatelessWidget {
  final String villageName;

  const ResidentProfileScreen({
    super.key,
    required this.villageName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button (top left)
            Positioned(
              left: 16,
              top: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 63,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Rounded header background
            Positioned(
              left: 10,
              top: -47,
              child: Transform.scale(
                scaleY: -1,
                child: Container(
                  width: 374,
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(43),
                  ),
                ),
              ),
            ),

            // Profile circle avatar
            Positioned(
              left: 22,
              top: 26,
              child: Container(
                width: 83,
                height: 84,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),

            // Profile label
            Positioned(
              left: 30,
              top: 59,
              child: Text(
                '프로필',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 0.75,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Nickname
            Positioned(
              left: 119,
              top: 50,
              child: Text(
                '닉네임',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  height: 0.64,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Nickname bar
            Positioned(
              left: 119,
              top: 81,
              child: Container(
                width: 247,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),

            // Intimacy bar label
            Positioned(
              left: 140,
              top: 81,
              child: Text(
                '친밀도 막대',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  height: 0.78,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Diamond rotated background
            Positioned(
              left: 21,
              top: 331,
              child: Transform.rotate(
                angle: 0.7854, // 45 degrees
                child: Container(
                  width: 244.66,
                  height: 243.95,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // Achievement boxes
            // Box 1 (left)
            Positioned(
              left: 44,
              top: 333,
              child: Container(
                width: 96,
                height: 163,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Box 2 (top center)
            Positioned(
              left: 149,
              top: 239,
              child: Container(
                width: 96,
                height: 163,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Box 3 (right)
            Positioned(
              left: 258,
              top: 333,
              child: Container(
                width: 96,
                height: 163,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Box 4 (bottom center)
            Positioned(
              left: 149,
              top: 422,
              child: Container(
                width: 96,
                height: 163,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Achievement title
            Positioned(
              left: 143,
              top: 367,
              child: Text(
                '업적가구들',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  height: 0.78,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Achievement description
            Positioned(
              left: 272,
              top: 376,
              child: SizedBox(
                width: 68,
                child: Text(
                  '퀴즈보상, 마을상점, 마을 업정 달성 시 받을 수 있음',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    height: 1.385,
                    letterSpacing: 0.01,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Heart emoji circle
            Positioned(
              left: 108,
              top: 709,
              child: Container(
                width: 41,
                height: 41,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: const Center(
                  child: Text(
                    '🩷',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Poop emoji circle
            Positioned(
              left: 173,
              top: 684,
              child: Container(
                width: 41,
                height: 41,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: const Center(
                  child: Text(
                    '💩',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Skull emoji circle
            Positioned(
              left: 237,
              top: 714,
              child: Container(
                width: 41,
                height: 41,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9D9D9),
                ),
                child: const Center(
                  child: Text(
                    '☠️',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Sticker button
            Positioned(
              left: 160,
              top: 750,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('스티커 붙히기')),
                  );
                },
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      '스티커',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.385,
                        letterSpacing: 0.01,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Sticker label
            Positioned(
              left: 174,
              top: 764,
              child: Text(
                '스티커 붙히기',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  height: 1.385,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
