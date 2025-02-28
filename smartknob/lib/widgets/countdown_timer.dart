import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CountdownTimer extends StatelessWidget {
  final int remainingTime;

  const CountdownTimer({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/timer_animation.json', // Smooth Lottie animation
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10),
        Text(
          remainingTime > 0 ? "$remainingTime sec" : "Time's up!",
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: remainingTime > 0 ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
