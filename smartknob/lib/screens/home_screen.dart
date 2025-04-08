import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/api_service.dart';
import 'volumecontrol_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  int remainingTime = 25 * 60;
  int lastSetTime = 25 * 60;
  bool isRunning = false;

  void startTimer() async {
    if (!isRunning) {
      await ApiService.startTimer(remainingTime);
      setState(() {
        isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            stopTimer();
          }
        });
      });
    }
  }

  void stopTimer() async {
    await ApiService.stopTimer();
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() async {
    await ApiService.resetTimer();
    _timer?.cancel();
    setState(() {
      remainingTime = lastSetTime;
      isRunning = false;
    });
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B4079),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SizedBox(
          height: 250,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.ms,
            initialTimerDuration: Duration(seconds: remainingTime),
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                remainingTime = newDuration.inSeconds;
                lastSetTime = newDuration.inSeconds;
              });
            },
          ),
        );
      },
    );
  }

  String formatTime() {
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF1B4079),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  Text(
                    "Stay focused, you're doing great!",
                    style: TextStyle(
                      color: const Color(0xFF4D7C8A),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTimerRing(),
                  const SizedBox(height: 30),
                  _buildSetTimeButton(),
                  const SizedBox(height: 30),
                  _buildControlButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        const VolumeControlScreen(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.timer_outlined, color: Colors.white, size: 26),
                SizedBox(width: 10),
                Text(
                  "Pomodoro Timer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerRing() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCBDF90).withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 6,
              ),
            ],
          ),
          child: CircularProgressIndicator(
            value: remainingTime / lastSetTime,
            strokeWidth: 14,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFCBDF90)),
          ),
        ),
        Text(
          formatTime(),
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB8D8D8),
          ),
        ),
      ],
    );
  }

  Widget _buildSetTimeButton() {
    return GestureDetector(
      onTap: _showTimePicker,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
  colors: [
    Color(0xFFCBDF90), // Mindaro
    Color(0xFF8FAD88), // Cambridge Blue
    Color(0xFF4D7C8A), // Deep Space Sparkle
    Color(0xFF1B4079), // Yale Blue
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
),

          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5151E5).withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.access_time_filled, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Set Timer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _neumorphicButton(
          label: isRunning ? "Pause" : "Start",
          icon: isRunning ? Icons.pause : Icons.play_arrow,
          onTap: isRunning ? stopTimer : startTimer,
        ),
        const SizedBox(width: 30),
        _neumorphicButton(
          label: "Reset",
          icon: Icons.restart_alt,
          onTap: resetTimer,
        ),
      ],
    );
  }

  Widget _neumorphicButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF7F9C96),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.white24,
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
