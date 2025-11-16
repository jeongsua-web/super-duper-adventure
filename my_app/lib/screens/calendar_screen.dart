import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final String villageName;

  const CalendarScreen({
    super.key,
    required this.villageName,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  int _getDaysInMonth(int month, int year) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  int _getFirstDayOfMonth(int month, int year) {
    return DateTime(year, month, 1).weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_currentDate.month, _currentDate.year);
    final firstDay = _getFirstDayOfMonth(_currentDate.month, _currentDate.year);
    final monthName = _getMonthName(_currentDate.month);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button (top left)
            Positioned(
              left: 16,
              top: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 63,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Header with year and navigation buttons
            Positioned(
              left: 46,
              top: 96,
              child: Text(
                '${_currentDate.year}',
                style: const TextStyle(
                  fontFamily: 'Jersey 20',
                  fontWeight: FontWeight.w400,
                  fontSize: 40,
                  height: 0.45,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Month navigation buttons (Y, M, W, D)
            Positioned(
              left: 76,
              top: 16,
              child: Row(
                children: [
                  _NavButton(label: 'Y', isSelected: false),
                  const SizedBox(width: 8),
                  _NavButton(label: 'M', isSelected: true),
                  const SizedBox(width: 8),
                  _NavButton(label: 'W', isSelected: false),
                  const SizedBox(width: 8),
                  _NavButton(label: 'D', isSelected: false),
                ],
              ),
            ),

            // Month title
            Positioned(
              left: 45,
              top: 126,
              child: Text(
                monthName,
                style: const TextStyle(
                  fontFamily: 'Jersey 20',
                  fontWeight: FontWeight.w400,
                  fontSize: 40,
                  height: 0.45,
                  letterSpacing: 0.01,
                  color: Colors.black,
                ),
              ),
            ),

            // Calendar container
            Positioned(
              left: 19,
              top: 75,
              child: Container(
                width: 356,
                height: 469,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Weekday headers (S M T W T F S)
                    Positioned(
                      left: 10,
                      top: 20,
                      child: SizedBox(
                        width: 335,
                        child: Text(
                          'S M T W T F S',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            height: 0.75,
                            letterSpacing: 0.55,
                            color: Color(0xFFEB5151),
                          ),
                        ),
                      ),
                    ),

                    // Calendar grid
                    Positioned(
                      left: 20,
                      top: 70,
                      child: _CalendarGrid(
                        daysInMonth: daysInMonth,
                        firstDay: firstDay,
                      ),
                    ),

                    // Selection indicator
                    Positioned(
                      right: 28,
                      top: 294,
                      child: Container(
                        width: 28,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBB0B0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Event 1
            Positioned(
              left: 19,
              top: 575,
              child: Container(
                width: 356,
                height: 51,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xFF8C6565), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 29,
                      top: 10,
                      child: Container(
                        width: 2,
                        height: 30,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      left: 41,
                      top: 16,
                      child: Text(
                        'play day with jisoo',
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          height: 0.75,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 16,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('수정')),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              'modify',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.286,
                                letterSpacing: 0.01,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Event 2
            Positioned(
              left: 19,
              top: 634,
              child: Container(
                width: 356,
                height: 51,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xFF8C6565), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 29,
                      top: 10,
                      child: Container(
                        width: 2,
                        height: 30,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      left: 100,
                      top: 16,
                      child: Text(
                        'spa day',
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          height: 0.75,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 16,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('수정')),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              'modify',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.286,
                                letterSpacing: 0.01,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add schedule button
            Positioned(
              left: 16,
              bottom: 24,
              child: Text(
                'add schedule',
                style: const TextStyle(
                  fontFamily: 'Jersey 20',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  height: 0.75,
                  color: Colors.black,
                ),
              ),
            ),

            // Add schedule input box
            Positioned(
              left: 16,
              bottom: 20,
              child: Container(
                width: 136,
                height: 23,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF706F6F), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Unblind button
            Positioned(
              left: 22,
              bottom: 150,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('일정 공개')),
                  );
                },
                child: Text(
                  'unblind',
                  style: const TextStyle(
                    fontFamily: 'Jersey 20',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.125,
                    letterSpacing: 0.01,
                    color: Color(0xFF8183F1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _NavButton({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        border: isSelected ? Border.all(color: Colors.black, width: 1) : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            height: 0.75,
            letterSpacing: 0.01,
            color: Color(0xFF4E4E4E),
          ),
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final int daysInMonth;
  final int firstDay;

  const _CalendarGrid({
    required this.daysInMonth,
    required this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    const double cellWidth = 45;
    const double cellHeight = 18;
    const double cellSpacing = 10;

    List<Widget> cells = [];

    // Empty cells for days before month starts
    for (int i = 0; i < firstDay; i++) {
      cells.add(SizedBox(width: cellWidth, height: cellHeight));
    }

    // Day numbers
    for (int day = 1; day <= daysInMonth; day++) {
      cells.add(
        SizedBox(
          width: cellWidth,
          height: cellHeight,
          child: Center(
            child: Text(
              day.toString(),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 0.75,
                letterSpacing: 0.01,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: cellSpacing,
      runSpacing: cellSpacing,
      children: cells,
    );
  }
}