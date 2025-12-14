import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarController extends GetxController {
  final String villageName;
  final String? villageId;

  CalendarController({
    required this.villageName,
    this.villageId,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<String?> resolvedVillageId = Rx<String?>(null);
  final RxBool isLoading = true.obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(DateTime.now());
  final RxMap<DateTime, List<Map<String, dynamic>>> events = 
      <DateTime, List<Map<String, dynamic>>>{}.obs;
  
  // 뷰 모드: 0=연간, 1=월간, 2=주간, 3=일간
  final RxInt viewMode = 1.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  
  final TextEditingController eventController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _resolveVillageId();
  }

  @override
  void onClose() {
    eventController.dispose();
    super.onClose();
  }

  Future<void> _resolveVillageId() async {
    if (villageId != null && villageId!.isNotEmpty) {
      resolvedVillageId.value = villageId;
      await loadEvents();
      isLoading.value = false;
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('villages')
          .where('name', isEqualTo: villageName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        resolvedVillageId.value = querySnapshot.docs.first.id;
        await loadEvents();
      }
      isLoading.value = false;
    } catch (e) {
      print('마을 ID 조회 오류: $e');
      isLoading.value = false;
    }
  }

  Future<void> loadEvents() async {
    if (resolvedVillageId.value == null) return;

    try {
      final snapshot = await _firestore
          .collection('villages')
          .doc(resolvedVillageId.value)
          .collection('events')
          .get();

      Map<DateTime, List<Map<String, dynamic>>> loadedEvents = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final Timestamp timestamp = data['date'];
        final DateTime eventDate = timestamp.toDate();
        final DateTime normalizedDate = 
            DateTime(eventDate.year, eventDate.month, eventDate.day);

        final eventData = {
          'id': doc.id,
          'title': data['title'],
          'creatorId': data['creatorId'],
          'creatorName': data['creatorName'],
        };

        if (loadedEvents[normalizedDate] == null) {
          loadedEvents[normalizedDate] = [];
        }
        loadedEvents[normalizedDate]!.add(eventData);
      }

      events.value = loadedEvents;
    } catch (e) {
      print('일정 로드 오류: $e');
    }
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  void onDaySelected(DateTime selectedDayParam, DateTime focusedDayParam) {
    selectedDay.value = selectedDayParam;
    focusedDay.value = focusedDayParam;
  }

  void onPageChanged(DateTime focusedDayParam) {
    focusedDay.value = focusedDayParam;
  }

  Future<void> addEvent() async {
    print('===== 일정 추가 시작 =====');
    print('VillageId: ${resolvedVillageId.value}');
    print('EventTitle: ${eventController.text}');
    print('SelectedDay: ${selectedDay.value}');

    if (resolvedVillageId.value == null) {
      print('오류: villageId가 null입니다');
      return;
    }
    if (eventController.text.trim().isEmpty) {
      print('오류: 일정 제목이 비어있습니다');
      return;
    }
    if (selectedDay.value == null) {
      print('오류: 선택된 날짜가 없습니다');
      return;
    }

    final user = _auth.currentUser;
    print('현재 사용자: ${user?.uid}');
    if (user == null) {
      print('오류: 로그인하지 않았습니다');
      Get.snackbar('오류', '로그인이 필요합니다');
      return;
    }

    try {
      final normalizedDate = DateTime(
        selectedDay.value!.year,
        selectedDay.value!.month,
        selectedDay.value!.day,
      );

      print('저장할 데이터:');
      print('  - title: ${eventController.text.trim()}');
      print('  - date: $normalizedDate');
      print('  - creatorId: ${user.uid}');
      print('  - creatorName: ${user.displayName ?? user.email ?? "익명"}');

      await _firestore
          .collection('villages')
          .doc(resolvedVillageId.value)
          .collection('events')
          .add({
        'title': eventController.text.trim(),
        'date': Timestamp.fromDate(normalizedDate),
        'creatorId': user.uid,
        'creatorName': user.displayName ?? user.email ?? '익명',
        'createdAt': Timestamp.now(),
      });

      print('일정 추가 성공!');
      eventController.clear();
      await loadEvents();

      Get.snackbar('성공', '일정이 추가되었습니다');
    } catch (e) {
      print('===== 일정 추가 오류 =====');
      print('오류: $e');
      print('========================');
      Get.snackbar('오류', '일정 추가 실패: $e');
    }
  }

  Future<void> deleteEvent(String eventId, String creatorId) async {
    final user = _auth.currentUser;
    if (user == null || user.uid != creatorId) {
      Get.snackbar('오류', '본인이 만든 일정만 삭제할 수 있습니다');
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('일정 삭제'),
        content: const Text('이 일정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _firestore
          .collection('villages')
          .doc(resolvedVillageId.value)
          .collection('events')
          .doc(eventId)
          .delete();

      await loadEvents();
      Get.snackbar('성공', '일정이 삭제되었습니다');
    } catch (e) {
      print('일정 삭제 오류: $e');
      Get.snackbar('오류', '일정 삭제에 실패했습니다');
    }
  }

  bool isCreator(String creatorId) {
    return _auth.currentUser?.uid == creatorId;
  }
}
