import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatelessWidget {
  final int remainingTime;

  const CountdownTimer({super.key, required this.remainingTime});

  String formatTime() {
    if (remainingTime < 60) {
      return '00:${remainingTime.toString().padLeft(2, '0')}';
    }
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            remainingTime > 0 ? formatTime() : "Time's up!",
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: remainingTime > 0 ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
