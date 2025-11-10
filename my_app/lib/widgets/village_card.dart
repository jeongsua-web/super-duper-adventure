import 'package:flutter/material.dart';

class VillageCard extends StatelessWidget {
  const VillageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text('마을 카드'),
      ),
    );
  }
}