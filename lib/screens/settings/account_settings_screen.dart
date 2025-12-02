import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그아웃 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 뒤로가기 버튼
          Positioned(
            left: 21,
            top: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 63,
                height: 38,
                decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                child: const Center(
                  child: Text(
                    '뒤로가기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      letterSpacing: 0.16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 계정 및 프로필
          const Positioned(
            left: 32,
            top: 111,
            child: Text(
              '계정 및 프로필',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.95,
                letterSpacing: 0.19,
              ),
            ),
          ),
          Positioned(
            left: 39,
            top: 164,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingItem(
                  text: '비밀번호 변경',
                  onTap: () {
                    // TODO: 비밀번호 변경
                  },
                ),
                _SettingItem(
                  text: '닉네임 변경 (60일)',
                  onTap: () {
                    // TODO: 닉네임 변경
                  },
                ),
                _SettingItem(
                  text: '다른계정으로 접속',
                  onTap: () {
                    // TODO: 계정 전환
                  },
                ),
                _SettingItem(
                  text: '로그아웃',
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
          
          // 알림
          const Positioned(
            left: 32,
            top: 375,
            child: Text(
              '알림',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.95,
                letterSpacing: 0.19,
              ),
            ),
          ),
          Positioned(
            left: 39,
            top: 424,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingItem(
                  text: '전체 알림 ON/OFF',
                  onTap: () {
                    // TODO: 알림 설정
                  },
                ),
                _SettingItem(
                  text: '채팅 퀴즈 캘린더 알림',
                  onTap: () {
                    // TODO: 세부 알림 설정
                  },
                ),
              ],
            ),
          ),
          
          // 개인
          const Positioned(
            left: 32,
            top: 573,
            child: Text(
              '개인',
              style: TextStyle(
                color: Colors.black,
                fontSize: 19,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.95,
                letterSpacing: 0.19,
              ),
            ),
          ),
          Positioned(
            left: 39,
            top: 622,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SettingItem(
                  text: '다크모드',
                  onTap: () {
                    // TODO: 다크모드
                  },
                ),
                _SettingItem(
                  text: '글꼴 크기 조정',
                  onTap: () {
                    // TODO: 글꼴 크기
                  },
                ),
                _SettingItem(
                  text: '애니메이션',
                  onTap: () {
                    // TODO: 애니메이션
                  },
                ),
              ],
            ),
          ),
          
          // 회원 탈퇴
          Positioned(
            left: 39,
            top: 790,
            child: GestureDetector(
              onTap: () {
                // TODO: 회원 탈퇴
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('회원 탈퇴'),
                    content: const Text('정말 탈퇴하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: 탈퇴 로직
                          Navigator.pop(context);
                        },
                        child: const Text('탈퇴', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                '회원 탈퇴',
                style: TextStyle(
                  color: Color(0xFFEB5050),
                  fontSize: 17,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.76,
                  letterSpacing: 0.17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SettingItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 23),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.17,
          ),
        ),
      ),
    );
  }
}
