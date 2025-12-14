import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  final String villageName;
  final String villageId;

  const SearchScreen({
    super.key,
    required this.villageName,
    required this.villageId,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];
  List<QueryDocumentSnapshot> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    // SharedPreferences 대신 간단하게 List로 관리
    setState(() {
      _recentSearches = [];
    });
  }

  void _addRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _recentSearches.removeWhere((item) => item == query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
    });
  }

  Future<void> _searchPosts(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // villageId 유효성 검사
    if (widget.villageId.isEmpty) {
      debugPrint('검색 오류: villageId가 비어있습니다');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('마을 정보를 찾을 수 없습니다')));
      return;
    }

    setState(() {
      // searching...
    });

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('villages')
          .doc(widget.villageId)
          .collection('posts')
          .get();

      // 클라이언트 측에서 제목에 검색어가 포함된 게시글 필터링
      final filteredDocs = result.docs.where((doc) {
        final title =
            (doc.data() as Map<String, dynamic>)['title']
                ?.toString()
                .toLowerCase() ??
            '';
        return title.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = filteredDocs;
      });

      _addRecentSearch(query);
    } catch (e) {
      debugPrint('검색 오류: $e');
      setState(() {
        _searchResults = [];
      });
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '방금 전';
    if (timestamp is! Timestamp) return '방금 전';
    DateTime date = timestamp.toDate();
    return '${date.month}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 그라디언트 헤더
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, 1.00),
                end: Alignment(0.50, 0.00),
                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 헤더 (X, 마을 이름)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 왼쪽: X 버튼
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        // 중앙: 마을 이름
                        Text(
                          widget.villageName,
                          style: GoogleFonts.gowunDodum(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // 오른쪽: 빈 공간 (균형 맞추기)
                        const SizedBox(width: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 검색 컨텐츠 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 검색창
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: '검색어 입력',
                            hintStyle: GoogleFonts.gowunDodum(
                              color: const Color(0xFF676767),
                              fontSize: 16,
                            ),
                            border: const OutlineInputBorder(),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchResults = [];
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _searchResults = [];
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          _searchPosts(_searchController.text);
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 검색 결과 또는 최근 검색어
                  Expanded(
                    child: _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final post = _searchResults[index];
                              final data = post.data() as Map<String, dynamic>;
                              String author = data['author'] ?? '익명';
                              String time = _formatTimestamp(data['createdAt']);
                              int viewCount = data['viewCount'] ?? 0;
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    '/post-detail',
                                    arguments: {
                                      'postId': post.id,
                                      'villageId': widget.villageId,
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFE0E0E0),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['title'] ?? '제목 없음',
                                              style: GoogleFonts.gowunDodum(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '$author | $time | $viewCount',
                                              style: GoogleFonts.gowunDodum(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (data['imageUrl'] != null) ...[
                                        const SizedBox(width: 12),
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFFC4ECF6),
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                            child: Image.network(
                                              data['imageUrl'] as String,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: const Color(
                                                        0xFFE0E0E0,
                                                      ),
                                                      child: const Icon(
                                                        Icons.image,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '최근 검색어',
                                style: GoogleFonts.gowunDodum(
                                  color: const Color(0xFF676767),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView(
                                  children: [
                                    ..._recentSearches.map((search) {
                                      return _buildSearchItem(
                                        search,
                                        onTap: () {
                                          _searchController.text = search;
                                          _searchPosts(search);
                                        },
                                        onDelete: () {
                                          setState(() {
                                            _recentSearches.remove(search);
                                          });
                                        },
                                      );
                                    }).toList(),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _recentSearches.clear();
                                          });
                                        },
                                        child: Text(
                                          '전체 삭제',
                                          style: GoogleFonts.gowunDodum(
                                            color: const Color(0xFF676767),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchItem(
    String text, {
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                text,
                style: GoogleFonts.gowunDodum(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onDelete,
            child: Text(
              '삭제',
              style: GoogleFonts.gowunDodum(
                color: const Color(0xFF676767),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
