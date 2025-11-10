import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정/기념일'),
      ),
      body: const Center(
        child: Text('일정/기념일 화면'),
      ),
    );
  }
}