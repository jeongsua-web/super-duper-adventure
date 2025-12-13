import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestbookScreen extends StatefulWidget {
  final String residentName;

  const GuestbookScreen({super.key, required this.residentName});

  @override
  State<GuestbookScreen> createState() => _GuestbookScreenState();
}

class _GuestbookScreenState extends State<GuestbookScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _guestbookEntries = [];

  void _addGuestbookEntry() {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('방명록을 입력해주세요')));
      return;
    }

    setState(() {
      _guestbookEntries.insert(0, {
        'content': _commentController.text,
        'timestamp': DateTime.now(),
        'author': '익명',
        'title': '새로운 방명록 🎉',
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: Column(
        children: [
          // Header with Profile Info
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Profile Card
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Profile Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.residentName,
                              style: GoogleFonts.gowunDodum(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '마을 관리자와의 친밀도',
                              style: GoogleFonts.gowunDodum(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: 0.8,
                                      minHeight: 10,
                                      backgroundColor: Colors.white,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.pink.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '80%',
                                  style: GoogleFonts.gowunDodum(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Guestbook List
          Expanded(
            child: _guestbookEntries.isEmpty
                ? Center(
                    child: Text(
                      '아직 방명록이 없습니다\n첫 번째 방명록을 남겨주세요!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gowunDodum(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _guestbookEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _guestbookEntries[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Author
                            Text(
                              entry['author'],
                              style: GoogleFonts.gowunDodum(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Content Box
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    entry['content'],
                                    style: GoogleFonts.gowunDodum(
                                      fontSize: 13,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF87CEEB),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '방명록을 작성하세요',
                      hintStyle: GoogleFonts.gowunDodum(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    minLines: 1,
                    style: GoogleFonts.gowunDodum(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addGuestbookEntry,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CDBFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
