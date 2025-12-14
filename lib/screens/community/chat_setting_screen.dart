import 'package:flutter/material.dart';

class ChatSettingScreen extends StatefulWidget {
  const ChatSettingScreen({super.key});

  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  // 스위치 상태 관리 변수들
  bool _isTypingStatusEnabled = false;
  bool _isAutoBackupEnabled = true; // 디자인상 켜져있는 것 같아 true로 설정
  bool _isAutoPlayEnabled = false;
  bool _isSwipeReplyEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '채팅방 설정', // 피그마에는 없지만 앱바 타이틀 추가 (필요 없으면 삭제 가능)
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        children: [
          _buildSectionTitle('채팅방'),
          _buildToggleRow(
            title: '메시지 입력 중 상태 보기',
            description: '채팅방에서 친구가 메시지 입력 중인 상태를 확인하고,\n내 상태도 공유 할 수 있습니다.',
            value: _isTypingStatusEnabled,
            onChanged: (val) => setState(() => _isTypingStatusEnabled = val),
          ),
          
          const SizedBox(height: 30),
          _buildSectionTitle('백업'),
          _buildToggleRow(
            title: '대화 자동 백업',
            description: '모든 기기의 대화와 사진, 동영상, 파일을 자동으로 백업하고\n언제든 복원할 수 있습니다.',
            value: _isAutoBackupEnabled,
            activeColor: const Color(0xFFC4ECF6), // 디자인에 있는 하늘색
            onChanged: (val) => setState(() => _isAutoBackupEnabled = val),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            title: '대화 임시 백업',
            description: '이 기기의 대화를 직접 백업하고 14일 이내 앱 재설치 시\n복원할 수 있습니다',
          ),

          const SizedBox(height: 30),
          _buildSectionTitle('미디어'),
          _buildToggleRow(
            title: '동영상 말풍선 자동재생',
            description: '채팅방에서 내려받은 동영상을 말풍선에서 자동으로 재생합니다.',
            value: _isAutoPlayEnabled,
            onChanged: (val) => setState(() => _isAutoPlayEnabled = val),
          ),

          const SizedBox(height: 30),
          _buildSectionTitle('말풍선'),
          _buildToggleRow(
            title: '스와이프로 답장하기',
            description: '말풍선을 왼쪽으로 밀어 답장 기능을 사용할 수 있습니다.',
            value: _isSwipeReplyEnabled,
            onChanged: (val) => setState(() => _isSwipeReplyEnabled = val),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // 섹션 제목 위젯 (채팅방, 미디어 등)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Gowun Dodum', // 폰트 적용
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // 토글 스위치가 있는 행 위젯
  Widget _buildToggleRow({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = const Color(0xFFC4ECF6),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontFamily: 'Gowun Dodum',
                color: Colors.black,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: activeColor,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD9D9D9),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 40), // 스위치 공간 확보
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gowun Dodum',
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // 토글 없이 정보만 있는 행 위젯 (대화 임시 백업용)
  Widget _buildInfoRow({required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontFamily: 'Gowun Dodum',
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gowun Dodum',
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}