import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text(
            '${controller.villageName} 캘린더',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Obx(() => TableCalendar(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: controller.focusedDay.value,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDay.value, day),
              eventLoader: controller.getEventsForDay,
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
              onDaySelected: controller.onDaySelected,
              onPageChanged: controller.onPageChanged,
            )),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.eventController,
                      decoration: const InputDecoration(
                        hintText: '일정 제목 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.addEvent,
                    child: const Text('추가'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.selectedDay.value == null) {
                  return const Center(child: Text('날짜를 선택하세요'));
                }
                return _buildEventList();
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEventList() {
    return Obx(() {
      final events = controller.getEventsForDay(controller.selectedDay.value!);

      if (events.isEmpty) {
        return const Center(
          child: Text('이 날짜에 일정이 없습니다'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final isCreator = controller.isCreator(event['creatorId']);

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(event['title']),
              subtitle: Text('작성자: ${event['creatorName']}'),
              trailing: isCreator
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteEvent(
                        event['id'],
                        event['creatorId'],
                      ),
                    )
                  : null,
            ),
          );
        },
      );
    });
  }
}
