import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetView<PostDetailController> {
  final String postId;
  final String villageId;

  const PostDetailView({
    super.key,
    required this.postId,
    required this.villageId,
  });

  @override
  Widget build(BuildContext context) {
    return PostDetailScreen(postId: postId, villageId: villageId);
  }
}

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final String villageId;

  const PostDetailScreen({
    super.key,
    required this.postId,
    required this.villageId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Map<String, bool> _likedPosts = {};

  Future<void> _toggleLike() async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .doc(widget.postId);

      final isLiked = _likedPosts[widget.postId] ?? false;

      setState(() {
        _likedPosts[widget.postId] = !isLiked;
      });

      if (isLiked) {
        await postRef.update({'likes': FieldValue.increment(-1)});
      } else {
        await postRef.update({'likes': FieldValue.increment(1)});
      }
    } catch (e) {
      debugPrint('좋아요 토글 오류: $e');
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    try {
      final postRef = FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .doc(widget.postId);

      // 댓글 추가
      await postRef.collection('comments').add({
        'content': _commentController.text,
        'author': '익명',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 댓글 수 증가
      await postRef.update({'comments': FieldValue.increment(1)});

      _commentController.clear();
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      debugPrint('댓글 추가 오류: $e');
    }
  }

  void _showPostMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('villages')
              .doc(widget.villageId)
              .collection('posts')
              .doc(widget.postId)
              .get(),
          builder: (context, snapshot) {
            final isPinned =
                (snapshot.data?.data() as Map<String, dynamic>?)?['isPinned'] ??
                false;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '게시글 관리',
                      style: GoogleFonts.gowunDodum(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Color(0xFF4DDBFF)),
                    title: Text(
                      '수정',
                      style: GoogleFonts.gowunDodum(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _editPost();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: Text(
                      '삭제',
                      style: GoogleFonts.gowunDodum(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _deletePost();
                    },
                  ),
                  if (!isPinned)
                    ListTile(
                      leading: const Icon(Icons.pin, color: Color(0xFFFFB800)),
                      title: Text(
                        '공지로 등록',
                        style: GoogleFonts.gowunDodum(fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _pinPost();
                      },
                    ),
                  if (isPinned)
                    ListTile(
                      leading: const Icon(
                        Icons.close,
                        color: Color(0xFFFFB800),
                      ),
                      title: Text(
                        '공지 등록취소',
                        style: GoogleFonts.gowunDodum(fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _unpinPost();
                      },
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _editPost() {
    // 수정 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('수정 기능은 준비 중입니다.', style: GoogleFonts.gowunDodum()),
      ),
    );
  }

  void _deletePost() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시글 삭제', style: GoogleFonts.gowunDodum()),
          content: Text('정말로 삭제하시겠습니까?', style: GoogleFonts.gowunDodum()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                '취소',
                style: GoogleFonts.gowunDodum(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performDelete();
              },
              child: Text(
                '삭제',
                style: GoogleFonts.gowunDodum(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDelete() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .doc(widget.postId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글이 삭제되었습니다.', style: GoogleFonts.gowunDodum()),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('게시글 삭제 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 중 오류가 발생했습니다.', style: GoogleFonts.gowunDodum()),
          ),
        );
      }
    }
  }

  Future<void> _pinPost() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .doc(widget.postId)
          .update({'isPinned': true});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('공지로 등록되었습니다.', style: GoogleFonts.gowunDodum()),
          ),
        );
      }
    } catch (e) {
      debugPrint('공지 등록 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '공지 등록 중 오류가 발생했습니다.',
              style: GoogleFonts.gowunDodum(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _unpinPost() async {
    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .doc(widget.postId)
          .update({'isPinned': false});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('공지 등록이 취소되었습니다.', style: GoogleFonts.gowunDodum()),
          ),
        );
      }
    } catch (e) {
      debugPrint('공지 등록취소 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '공지 등록취소 중 오류가 발생했습니다.',
              style: GoogleFonts.gowunDodum(),
            ),
          ),
        );
      }
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '방금 전';
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return '${date.month}.${date.day.toString().padLeft(2, '0')}';
    }
    return '방금 전';
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 헤더 (하늘색 배경)
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('villages')
                .doc(widget.villageId)
                .collection('posts')
                .doc(widget.postId)
                .get(),
            builder: (context, snapshot) {
              final title =
                  (snapshot.data?.data() as Map<String, dynamic>?)?['title'] ??
                  '게시글';

              return Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 15,
                  left: 16,
                  right: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4DDBFF), Color(0xFFC4ECF6)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 닫기 버튼
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    // 제목
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: GoogleFonts.gowunDodum(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // 메뉴 버튼
                    GestureDetector(
                      onTap: _showPostMenu,
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 스크롤 영역
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 작성자 정보 섹션
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('villages')
                        .doc(widget.villageId)
                        .collection('posts')
                        .doc(widget.postId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      if (data == null) return const SizedBox.shrink();

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFD9D9D9),
                              child: Image.network(
                                'https://via.placeholder.com/48',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 28,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data['author'] ?? '익명',
                                        style: GoogleFonts.gowunDodum(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        data['subtitle'] ?? '',
                                        style: GoogleFonts.gowunDodum(
                                          fontSize: 12,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _formatTimestamp(data['createdAt']),
                                    style: GoogleFonts.gowunDodum(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // 게시글 이미지
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('villages')
                        .doc(widget.villageId)
                        .collection('posts')
                        .doc(widget.postId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      final imageUrl = data?['imageUrl'] as String?;

                      if (imageUrl != null && imageUrl.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 250,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 30),

                  // 게시글 내용
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('villages')
                        .doc(widget.villageId)
                        .collection('posts')
                        .doc(widget.postId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 30,
                        ),
                        child: Text(
                          data?['content'] ?? '',
                          style: GoogleFonts.gowunDodum(
                            fontSize: 16,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // 구분선
                  Divider(height: 32, thickness: 1),

                  const SizedBox(height: 4),

                  // 좋아요 및 댓글 수
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('villages')
                        .doc(widget.villageId)
                        .collection('posts')
                        .doc(widget.postId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      final comments = data?['comments'] ?? 0;
                      final isLiked = _likedPosts[widget.postId] ?? false;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 중앙 하트
                            GestureDetector(
                              onTap: _toggleLike,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // 채워진 분홍색 하트
                                        if (isLiked)
                                          Icon(
                                            Icons.favorite,
                                            color: const Color(0xFFF3CCD4),
                                            size: 22,
                                          )
                                        else
                                          // 빈 하트 (검정 테두리)
                                          Icon(
                                            Icons.favorite_border,
                                            color: Colors.black,
                                            size: 22,
                                          ),
                                        // 검정색 테두리 (위에 겹침)
                                        if (isLiked)
                                          Icon(
                                            Icons.favorite_border,
                                            color: Colors.black,
                                            size: 22,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 좌측 댓글
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '댓글 $comments',
                                style: GoogleFonts.gowunDodum(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Divider(height: 32, thickness: 1),

                  // 댓글 목록
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('villages')
                          .doc(widget.villageId)
                          .collection('posts')
                          .doc(widget.postId)
                          .collection('comments')
                          .orderBy('createdAt', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final comments = snapshot.data!.docs;

                        if (comments.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              '첫 번째 댓글을 남겨보세요!',
                              style: GoogleFonts.gowunDodum(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: comments.map((doc) {
                            final commentData =
                                doc.data() as Map<String, dynamic>;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.grey[300],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          commentData['author'] ?? '익명',
                                          style: GoogleFonts.gowunDodum(
                                            fontSize: 11,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          commentData['content'] ?? '',
                                          style: GoogleFonts.gowunDodum(
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          _formatTimestamp(
                                            commentData['createdAt'],
                                          ),
                                          style: GoogleFonts.gowunDodum(
                                            fontSize: 9,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 댓글 입력창 (하단 고정)
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 작성하세요',
                        hintStyle: GoogleFonts.gowunDodum(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                      style: GoogleFonts.gowunDodum(fontSize: 13),
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addComment,
                  child: Icon(Icons.send, color: Colors.grey[400], size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
