import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: Obx(() {
                  switch (controller.viewMode.value) {
                    case 0:
                      return _buildYearView();
                    case 1:
                      return _buildMonthView();
                    case 2:
                      return _buildWeekView();
                    case 3:
                      return _buildDayView();
                    default:
                      return _buildMonthView();
                  }
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 31,
              height: 27,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 76),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTab('년', 0),
          const SizedBox(width: 12),
          _buildTab('월', 1),
          const SizedBox(width: 12),
          _buildTab('주', 2),
          const SizedBox(width: 12),
          _buildTab('일', 3),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int mode) {
    return Obx(() {
      final isSelected = controller.viewMode.value == mode;
      return GestureDetector(
        onTap: () => controller.viewMode.value = mode,
        child: Container(
          width: 51,
          height: 30,
          decoration: ShapeDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment(0.50, 1.00),
                    end: Alignment(0.50, 0.00),
                    colors: [Color(0xFF4CDBFF), Color(0xFFC4ECF6)],
                  )
                : null,
            color: isSelected ? null : const Color(0xFFC4ECF6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Gowun Dodum',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    });
  }

  // 연간 뷰
  Widget _buildYearView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // 년도 표시 및 화살표
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => controller.selectedYear.value--,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFC4ECF6),
                    shape: OvalBorder(),
                  ),
                  child: Transform.rotate(
                    angle: 3.14,
                    child: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Obx(
                () => Text(
                  '${controller.selectedYear.value}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Color(0xFFC4ECF6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => controller.selectedYear.value++,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFC4ECF6),
                    shape: OvalBorder(),
                  ),
                  child: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 12개월 그리드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 27,
                childAspectRatio: 1.0,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.focusedDay.value = DateTime(
                      controller.selectedYear.value,
                      index + 1,
                      1,
                    );
                    controller.viewMode.value = 1; // 월간으로 전환
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFC4ECF6),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.50,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}월',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          // 연간 이벤트
          Obx(
            () => Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF4CDBFF)),
                ),
              ),
              child: Text(
                '${controller.selectedYear.value}년도의 큰 이벤트',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Gowun Dodum',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 연간 이벤트 리스트 (예시)
          _buildYearEventList(),
        ],
      ),
    );
  }

  Widget _buildYearEventList() {
    return Obx(() {
      // Firebase에서 가져온 실제 연간 이벤트
      final yearEvents = <Map<String, String>>[];

      controller.events.forEach((date, eventList) {
        if (date.year == controller.selectedYear.value) {
          for (var event in eventList) {
            yearEvents.add({
              'title': event['title'] ?? '',
              'date':
                  '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
            });
          }
        }
      });

      if (yearEvents.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              '이 년도에 등록된 이벤트가 없습니다',
              style: TextStyle(
                color: Color(0xFF686868),
                fontSize: 16,
                fontFamily: 'Gowun Dodum',
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: yearEvents.map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 11,
                    height: 11,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFC4ECF6),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      event['title']!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    event['date']!,
                    style: const TextStyle(
                      color: Color(0xFF686868),
                      fontSize: 18,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  // 월간 뷰
  Widget _buildMonthView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          // 월간 캘린더 컨테이너
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.50, 1.00),
                end: Alignment(0.50, 0.00),
                colors: [Color(0xFFC4ECF6), Color(0xFF4CDBFF)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Column(
              children: [
                Obx(
                  () => Text(
                    '${controller.focusedDay.value.year}\n${controller.focusedDay.value.month}월',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                      height: 1.09,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white, height: 1),
                const SizedBox(height: 16),
                // 요일 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeekDayLabel('일', Colors.red),
                    _buildWeekDayLabel('월', Colors.black),
                    _buildWeekDayLabel('화', Colors.black),
                    _buildWeekDayLabel('수', Colors.black),
                    _buildWeekDayLabel('목', Colors.black),
                    _buildWeekDayLabel('금', Colors.black),
                    _buildWeekDayLabel('토', const Color(0xFF1215D7)),
                  ],
                ),
                const SizedBox(height: 16),
                // 날짜 그리드
                _buildMonthCalendarGrid(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 페이지 인디케이터
          _buildPageIndicator(),
          const SizedBox(height: 16),
          // 일정 목록
          _buildMonthEventList(),
          const SizedBox(height: 16),
          // 스케줄 생성 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => _showCreateEventDialog(),
              child: Container(
                height: 32,
                decoration: ShapeDecoration(
                  color: const Color(0xFFC4ECF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '스케줄 생성',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWeekDayLabel(String label, Color color) {
    return SizedBox(
      width: 40,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontFamily: 'Gowun Dodum',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildMonthCalendarGrid() {
    return Obx(() {
      final year = controller.focusedDay.value.year;
      final month = controller.focusedDay.value.month;
      final firstDay = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0);
      final daysInMonth = lastDay.day;
      final startWeekday = firstDay.weekday % 7; // 0=일요일

      List<Widget> dayWidgets = [];

      // 빈 칸 추가
      for (int i = 0; i < startWeekday; i++) {
        dayWidgets.add(const SizedBox(width: 40, height: 35));
      }

      // 날짜 추가
      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(year, month, day);
        final isSelected =
            controller.selectedDay.value != null &&
            date.year == controller.selectedDay.value!.year &&
            date.month == controller.selectedDay.value!.month &&
            date.day == controller.selectedDay.value!.day;

        final hasEvents = controller.getEventsForDay(date).isNotEmpty;

        dayWidgets.add(
          GestureDetector(
            onTap: () => controller.selectedDay.value = date,
            child: Container(
              width: 40,
              height: 35,
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    )
                  : null,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '$day',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (hasEvents)
                    Positioned(
                      bottom: 2,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }

      return Wrap(spacing: 5, runSpacing: 8, children: dayWidgets);
    });
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(14, (index) {
        return Container(
          width: 11,
          height: 11,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: const ShapeDecoration(
            color: Color(0xFFC4ECF6),
            shape: OvalBorder(),
          ),
        );
      }),
    );
  }

  Widget _buildMonthEventList() {
    return Obx(() {
      if (controller.selectedDay.value == null) {
        return const SizedBox();
      }

      final events = controller.getEventsForDay(controller.selectedDay.value!);

      if (events.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Text('선택한 날짜에 일정이 없습니다'),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: events.map((event) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 40,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.50, 1.00),
                        end: Alignment(0.50, 0.00),
                        colors: [Color(0xFF4CDBFF), Color(0xFFC4ECF6)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'by ${event['creatorName']}',
                          style: const TextStyle(
                            color: Color(0xFF4CDBFF),
                            fontSize: 13,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '하루종일',
                    style: TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 13,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final memoController = TextEditingController();
    final isAllDay = false.obs;
    final selectedDate = controller.selectedDay.value ?? DateTime.now();
    final startTime = '4:30PM'.obs;
    final endTime = '5PM'.obs;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 393,
          height: 762,
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      '[스케줄 생성]',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 71),
                  // 날짜
                  Row(
                    children: [
                      const Text(
                        '날짜',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 100,
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xFF4CDBFF),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${selectedDate.year.toString().substring(2)}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // 스케줄 제목
                  const Text(
                    '스케줄 제목',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Column(
                    children: [
                      Container(
                        height: 37,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFF4CDBFF),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: TextField(
                          controller: titleController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            hintText: '입력하세요',
                            hintStyle: TextStyle(
                              color: Color(0xFFBFBFBF),
                              fontSize: 16,
                              fontFamily: 'Gowun Dodum',
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            'blind',
                            style: TextStyle(
                              color: Color(0xFF8183F1),
                              fontSize: 12,
                              fontFamily: 'Jersey 20',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // 시간
                  const Text(
                    '시간',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 하루종일 체크박스
                  Obx(
                    () => Row(
                      children: [
                        GestureDetector(
                          onTap: () => isAllDay.value = !isAllDay.value,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: isAllDay.value
                                  ? const Color(0xFF4CDBFF)
                                  : Colors.white,
                              border: Border.all(
                                color: const Color(0xFF4CDBFF),
                                width: 1,
                              ),
                            ),
                            child: isAllDay.value
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '하루종일',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 시작 시간
                  const Text(
                    '시작 시간',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 110,
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          startTime.value,
                          style: const TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 13,
                            fontFamily: 'Jersey 20',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 끝나는 시간
                  const Text(
                    '끝나는 시간',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 110,
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          endTime.value,
                          style: const TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 13,
                            fontFamily: 'Jersey 20',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  // 메모
                  const Text(
                    '메모',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Gowun Dodum',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 91,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF4CDBFF),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: memoController,
                      maxLines: 4,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        hintText: '입력하세요!',
                        hintStyle: TextStyle(
                          color: Color(0xFFA7A7A7),
                          fontSize: 14,
                          fontFamily: 'Gowun Dodum',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  // 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 취소
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 65,
                          height: 37,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Color(0xFFEBAFAF),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: Color(0xFFC73838),
                                fontSize: 20,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // 저장
                      GestureDetector(
                        onTap: () {
                          if (titleController.text.isNotEmpty) {
                            controller.eventController.text =
                                titleController.text;
                            controller.addEvent();
                            Get.back();
                          }
                        },
                        child: Container(
                          width: 65,
                          height: 37,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFC4ECF6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '저장',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 주간 뷰
  Widget _buildWeekView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // 주간 헤더
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFFC4ECF6),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF4CDBFF)),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Center(
              child: Obx(
                () => Text(
                  '${controller.focusedDay.value.year} ${controller.focusedDay.value.month}월',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 요일 및 날짜
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeekDayLabel('일', Colors.red),
                _buildWeekDayLabel('월', Colors.black),
                _buildWeekDayLabel('화', Colors.black),
                _buildWeekDayLabel('수', Colors.black),
                _buildWeekDayLabel('목', Colors.black),
                _buildWeekDayLabel('금', Colors.black),
                _buildWeekDayLabel('토', const Color(0xFF1215D7)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 주간 날짜
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Obx(() {
              final weekDates = _getWeekDates();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDates.map((date) {
                  return SizedBox(
                    width: 40,
                    child: Text(
                      '${date.day}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          const SizedBox(height: 24),
          // 시간별 스케줄 그리드
          _buildWeekScheduleGrid(),
        ],
      ),
    );
  }

  List<DateTime> _getWeekDates() {
    final today = controller.focusedDay.value;
    final weekday = today.weekday % 7; // 0=일요일
    final sunday = today.subtract(Duration(days: weekday));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  Widget _buildWeekScheduleGrid() {
    final hours = [
      '1pm',
      '2pm',
      '3pm',
      '4pm',
      '5pm',
      '6pm',
      '7pm',
      '8pm',
      '9pm',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(hours.length, (index) {
          return Column(
            children: [
              Container(height: 3, color: const Color(0xFF4CDBFF)),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        // 주간의 각 날짜별 이벤트 표시
                        final weekDates = _getWeekDates();
                        return Row(
                          children: List.generate(7, (dayIndex) {
                            final date = weekDates[dayIndex];
                            final events = controller.getEventsForDay(date);
                            final hasEvent = events.isNotEmpty;

                            return Expanded(
                              child: hasEvent && index == 0
                                  ? Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFC4ECF6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                        );
                      }),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        hours[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 일간 뷰
  Widget _buildDayView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // 일간 헤더
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 21),
            height: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFFC4ECF6),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFF4CDBFF)),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: Center(
              child: Obx(
                () => Text(
                  '${controller.focusedDay.value.year} ${controller.focusedDay.value.month}월',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 요일 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeekDayLabel('일', Colors.red),
                _buildWeekDayLabel('월', Colors.black),
                _buildWeekDayLabel('화', Colors.black),
                _buildWeekDayLabel('수', Colors.black),
                _buildWeekDayLabel('목', Colors.black),
                _buildWeekDayLabel('금', Colors.black),
                _buildWeekDayLabel('토', const Color(0xFF1215D7)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 주간 날짜
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Obx(() {
              final weekDates = _getWeekDates();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDates.map((date) {
                  final isToday =
                      date.year == controller.focusedDay.value.year &&
                      date.month == controller.focusedDay.value.month &&
                      date.day == controller.focusedDay.value.day;

                  return GestureDetector(
                    onTap: () => controller.focusedDay.value = date,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${date.day}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isToday)
                          Container(
                            width: 20,
                            height: 4,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFC4ECF6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          const SizedBox(height: 24),
          // 시간별 스케줄
          _buildDayScheduleGrid(),
        ],
      ),
    );
  }

  Widget _buildDayScheduleGrid() {
    final hours = [
      '1pm',
      '2pm',
      '3pm',
      '4pm',
      '5pm',
      '6pm',
      '7pm',
      '8pm',
      '9pm',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Obx(() {
        final events = controller.getEventsForDay(controller.focusedDay.value);

        return Column(
          children: List.generate(hours.length, (index) {
            return Column(
              children: [
                Container(
                  height: 3,
                  width: 353,
                  color: const Color(0xFF4CDBFF),
                ),
                SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      // 실제 이벤트 표시
                      if (events.isNotEmpty && index == 0)
                        Positioned(
                          left: 1,
                          top: 4,
                          child: Container(
                            width: 315,
                            height: 121,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFC4ECF6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 16,
                                  top: 55,
                                  child: Text(
                                    events.first['title'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 5,
                                  top: 63,
                                  child: Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const ShapeDecoration(
                                      color: Colors.black,
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // 시간 라벨
                      Positioned(
                        right: 0,
                        top: -15,
                        child: SizedBox(
                          width: 40,
                          child: Text(
                            hours[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        );
      }),
    );
  }
}
