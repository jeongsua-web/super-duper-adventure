import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/user_controller.dart';
import '../controllers/account_settings_controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountSettingsScreen();
  }
}

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late bool _isDarkMode;
  bool _isAllNotificationsEnabled = true;
  bool _isChatNotificationsEnabled = true;
  bool _isQuizNotificationsEnabled = true;
  bool _isCalendarNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _isDarkMode = false;
  }

  Future<void> _logout(BuildContext context) async {
    try {
      print('[AccountSettings] 로그아웃 버튼 클릭됨');
      final userController = Get.find<UserController>();
      await userController.logout();
      print('[AccountSettings] UserController 로그아웃 완료');
    } catch (e) {
      print('[AccountSettings] 로그아웃 실패: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
        ),
        leadingWidth: 60,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 계정 및 프로필 섹션
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '계정 및 프로필',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 32),
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
                      _SettingItem(text: '로그아웃', onTap: () => _logout(context)),
                    ],
                  ),
                ),

                // 알림 섹션
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '알림',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '전체 알림 ON/OFF',
                            style: GoogleFonts.gowunDodum(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _isAllNotificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isAllNotificationsEnabled = value;
                                  _isChatNotificationsEnabled = value;
                                  _isQuizNotificationsEnabled = value;
                                  _isCalendarNotificationsEnabled = value;
                                });
                                // TODO: 알림 설정 저장
                              },
                              activeColor: const Color(0xFFC4ECF6),
                              trackColor: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '채팅 알림',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: _isChatNotificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _isChatNotificationsEnabled = value;
                                  });
                                  // TODO: 채팅 알림 설정 저장
                                },
                                activeColor: const Color(0xFFC4ECF6),
                                trackColor: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '퀴즈 알림',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: _isQuizNotificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _isQuizNotificationsEnabled = value;
                                  });
                                  // TODO: 퀴즈 알림 설정 저장
                                },
                                activeColor: const Color(0xFFC4ECF6),
                                trackColor: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '캘린더 알림',
                              style: GoogleFonts.gowunDodum(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: _isCalendarNotificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _isCalendarNotificationsEnabled = value;
                                  });
                                  // TODO: 캘린더 알림 설정 저장
                                },
                                activeColor: const Color(0xFFC4ECF6),
                                trackColor: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 개인 섹션
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '개인',
                    style: GoogleFonts.gowunDodum(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '다크모드',
                            style: GoogleFonts.gowunDodum(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() {
                                  _isDarkMode = value;
                                });
                              },
                              activeColor: const Color(0xFFC4ECF6),
                              trackColor: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: _SettingItem(
                          text: '글꼴 크기 조정',
                          onTap: () {
                            // TODO: 글꼴 크기
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: _SettingItem(
                          text: '애니메이션',
                          onTap: () {
                            // TODO: 애니메이션
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // 회원 탈퇴
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 40),
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
                              child: const Text(
                                '탈퇴',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      '회원 탈퇴',
                      style: TextStyle(
                        color: Color(0xFFEB5050),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
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
}

class _SettingItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SettingItem({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 23),
        child: Text(
          text,
          style: GoogleFonts.gowunDodum(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
