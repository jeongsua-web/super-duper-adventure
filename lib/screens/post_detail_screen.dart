import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  // [기능 1] 댓글 저장 함수 (수정됨: 숫자 증가 기능 추가)
  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    // 1. 댓글 내용 저장 (원래 있던 코드)
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'content': _commentController.text,
      'author': '익명', // 나중에 로그인한 사용자 이름으로 교체
      'createdAt': FieldValue.serverTimestamp(),
    });

    // ---------------------------------------------------------
    // [★ 핵심 수정] 게시글의 'comments' 숫자 필드를 +1 해줍니다.
    // ---------------------------------------------------------
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({
      // 'comments'는 아까 파이어베이스에 만들어둔 필드 이름과 똑같아야 합니다.
      'comments': FieldValue.increment(1), 
    });

    // 입력창 비우기 및 키보드 내리기
    _commentController.clear();
    if (mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  // 날짜 포맷 함수
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '방금 전';
    DateTime date = timestamp.toDate();
    return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('게시글 상세'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // --- 게시글 내용 & 댓글 목록 (스크롤 영역) ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // [1] 게시글 데이터 가져오기 (FutureBuilder)
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final data = snapshot.data!.data() as Map<String, dynamic>?;
                          if (data == null) return const Text("삭제된 글입니다.");

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] ?? '제목 없음',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFFD9D9D9),
                                    child: Icon(Icons.person, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['author'] ?? '익명',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _formatTimestamp(data['createdAt']),
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 40, thickness: 1),
                              Text(
                                data['content'] ?? '',
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ],
                          );
                        },
                      ),

                      const Divider(height: 40, thickness: 1),

                      // [2] 댓글 목록 (StreamBuilder로 실시간 감시)
                      const Text(
                        '댓글',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId) // 현재 글 안의
                            .collection('comments') // comments 폴더 감시
                            .orderBy('createdAt', descending: false) // 과거순 정렬
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("댓글을 불러오는 중...");
                          }
                          final comments = snapshot.data!.docs;

                          if (comments.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text("첫 번째 댓글을 남겨보세요!"),
                            );
                          }

                          // 댓글 리스트 뿌리기
                          return ListView.builder(
                            shrinkWrap: true, // 스크롤뷰 안에 리스트뷰 넣을 때 필수
                            physics: const NeverScrollableScrollPhysics(), // 스크롤 막기 (부모 스크롤 사용)
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final commentData =
                                  comments[index].data() as Map<String, dynamic>;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          commentData['author'] ?? '익명',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        Text(
                                          _formatTimestamp(commentData['createdAt']),
                                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(commentData['content'] ?? ''),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // --- [3] 댓글 입력창 (하단 고정) ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _commentController, // 컨트롤러 연결
                          decoration: const InputDecoration(
                            hintText: '댓글을 입력하세요...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _addComment(), // 엔터 쳐도 전송
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addComment, // 버튼 누르면 전송
                      icon: const Icon(Icons.send, color: Color(0xFFFFA9A9)),
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