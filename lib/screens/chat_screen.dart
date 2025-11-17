import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String villageName;

  const ChatScreen({
    super.key,
    required this.villageName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, String>> _messages = [
    {
      'nickname': '닉네임',
      'message': '너희들은 아보카도 두개 먹어라!',
    },
    {
      'nickname': '닉네임2',
      'message': '너희들은 아보카도 한개 먹어라!',
    },
    {
      'nickname': '닉네임3',
      'message': '너희들은 아보카도 세개 먹어라!',
    },
    {
      'nickname': '닉네임4',
      'message': '너희들은 아보카도 다섯개 먹어라!',
    },
    {
      'nickname': '닉네임4',
      'message': '너희들은 아보카도 여섯개 먹어라!',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Top header divider
            Positioned(
              left: 0,
              top: 54,
              child: Container(
                width: 393,
                height: 2,
                color: const Color(0xFFD9D9D9),
              ),
            ),

            // Back button (top left)
            Positioned(
              left: 10,
              top: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD9D9D9),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Search button (top center)
            Positioned(
              left: 277,
              top: 8,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('채팅 검색')),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD9D9D9),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Settings button (top right)
            Positioned(
              left: 326,
              top: 8,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('채팅 설정')),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD9D9D9),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.settings,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Messages list
            Positioned(
              left: 0,
              top: 70,
              right: 0,
              bottom: 90,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _ChatMessageBubble(
                    nickname: msg['nickname']!,
                    message: msg['message']!,
                  );
                },
              ),
            ),

            // Question bubble
            Positioned(
              left: 119,
              top: 744,
              child: Container(
                width: 155,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Text(
                    '폭죽을 터트리겠습니까?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      height: 1.286,
                      letterSpacing: 0.01,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Reaction circle
            Positioned(
              left: 178,
              top: 695,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD9D9D9),
                  border: Border.all(color: const Color(0xFFA3A3A3), width: 1),
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            // Bottom input area
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFF595959),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  children: [
                    // Attach file button
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('첨부파일')),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.attachment,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Message input field
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: '메시지 입력',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Send button
                    GestureDetector(
                      onTap: () {
                        if (_messageController.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '메시지 전송: ${_messageController.text}',
                              ),
                            ),
                          );
                          _messageController.clear();
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            size: 18,
                            color: Colors.black,
                          ),
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
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final String nickname;
  final String message;

  const _ChatMessageBubble({
    required this.nickname,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info with avatar
          Row(
            children: [
              // Avatar
              Container(
                width: 58.34,
                height: 58.34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC2C2C2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Nickname
              Text(
                nickname,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 0.9,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Message bubble
          Container(
            margin: const EdgeInsets.only(left: 70),
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w200,
                fontSize: 20,
                height: 0.9,
                letterSpacing: 0.01,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
