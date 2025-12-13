import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarScreen extends StatefulWidget {
  final String villageName;
  final String? villageId;

  const CalendarScreen({super.key, required this.villageName, this.villageId});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String? _resolvedVillageId;
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _resolveVillageId();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  Future<void> _resolveVillageId() async {
    if (widget.villageId != null && widget.villageId!.isNotEmpty) {
      setState(() {
        _resolvedVillageId = widget.villageId;
      });
      await _loadEvents();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('villages')
          .where('name', isEqualTo: widget.villageName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _resolvedVillageId = querySnapshot.docs.first.id;
        });
        await _loadEvents();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('마을 ID 조회 오류: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadEvents() async {
    if (_resolvedVillageId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('villages')
          .doc(_resolvedVillageId)
          .collection('events')
          .get();

      Map<DateTime, List<Map<String, dynamic>>> events = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final Timestamp timestamp = data['date'];
        final DateTime eventDate = timestamp.toDate();
        final DateTime normalizedDate = DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
        );

        final eventData = {
          'id': doc.id,
          'title': data['title'],
          'creatorId': data['creatorId'],
          'creatorName': data['creatorName'],
        };

        if (events[normalizedDate] == null) {
          events[normalizedDate] = [];
        }
        events[normalizedDate]!.add(eventData);
      }

      setState(() {
        _events = events;
      });
    } catch (e) {
      print('일정 로드 오류: $e');
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  Future<void> _addEvent() async {
    print('===== 일정 추가 시작 =====');
    print('VillageId: $_resolvedVillageId');
    print('EventTitle: ${_eventController.text}');
    print('SelectedDay: $_selectedDay');

    if (_resolvedVillageId == null) {
      print('오류: villageId가 null입니다');
      return;
    }
    if (_eventController.text.trim().isEmpty) {
      print('오류: 일정 제목이 비어있습니다');
      return;
    }
    if (_selectedDay == null) {
      print('오류: 선택된 날짜가 없습니다');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    print('현재 사용자: ${user?.uid}');
    if (user == null) {
      print('오류: 로그인하지 않았습니다');
      return;
    }

    try {
      final normalizedDate = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
      );

      print('저장할 데이터:');
      print('  - title: ${_eventController.text.trim()}');
      print('  - date: $normalizedDate');
      print('  - creatorId: ${user.uid}');
      print('  - creatorName: ${user.displayName ?? user.email ?? "익명"}');

      await FirebaseFirestore.instance
          .collection('villages')
          .doc(_resolvedVillageId)
          .collection('events')
          .add({
            'title': _eventController.text.trim(),
            'date': Timestamp.fromDate(normalizedDate),
            'creatorId': user.uid,
            'creatorName': user.displayName ?? user.email ?? '익명',
            'createdAt': Timestamp.now(),
          });

      print('일정 추가 성공!');
      _eventController.clear();
      await _loadEvents();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('일정이 추가되었습니다')));
      }
    } catch (e) {
      print('===== 일정 추가 오류 =====');
      print('오류: $e');
      print('========================');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('일정 추가 실패: $e')));
      }
    }
  }

  Future<void> _deleteEvent(String eventId, String creatorId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid != creatorId) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('본인이 만든 일정만 삭제할 수 있습니다')));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 삭제'),
        content: const Text('이 일정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('villages')
          .doc(_resolvedVillageId)
          .collection('events')
          .doc(eventId)
          .delete();

      await _loadEvents();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('일정이 삭제되었습니다')));
      }
    } catch (e) {
      print('일정 삭제 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('일정 삭제에 실패했습니다')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.villageName} 캘린더',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(
                      hintText: '일정 제목 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addEvent, child: const Text('추가')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('날짜를 선택하세요'))
                : _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay!);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (events.isEmpty) {
      return const Center(child: Text('이 날짜에 일정이 없습니다'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isCreator = currentUser?.uid == event['creatorId'];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(event['title']),
            subtitle: Text('작성자: ${event['creatorName']}'),
            trailing: isCreator
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _deleteEvent(event['id'], event['creatorId']),
                  )
                : null,
          ),
        );
      },
    );
  }
}
