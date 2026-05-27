import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final String formattedTime;

  const TimerDisplay({super.key, required this.formattedTime});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        formattedTime,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}