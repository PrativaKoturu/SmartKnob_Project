import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  int remainingTime = 25 * 60;
  int lastSetTime = 25 * 60; // Store the last set time
  bool isRunning = false;
  final TextEditingController _timeController = TextEditingController();

  void startTimer() async {
    if (!isRunning) {
      await ApiService.startTimer(remainingTime); // Pass the custom time
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

  void setCustomTime() {
    if (_timeController.text.isNotEmpty) {
      int? inputSeconds = int.tryParse(_timeController.text);
      if (inputSeconds != null && inputSeconds > 0) {
        setState(() {
          remainingTime = inputSeconds;
          lastSetTime = inputSeconds; // Store the custom time
          _timeController.clear();
        });
      }
    }
  }

  String formatTime() {
    // Changed to show total seconds if less than 60
    if (remainingTime < 60) {
      return '00:${remainingTime.toString().padLeft(2, '0')}';
    }
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void resetTimer() async {
    await ApiService.resetTimer();
    _timer?.cancel();
    setState(() {
      remainingTime = lastSetTime; // Use the last set time instead of 25 * 60
      isRunning = false;
    });
  }

  @override
  void dispose() {
    _timeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Pomodoro Timer',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              // Add input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _timeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter time in seconds",
                    hintStyle: const TextStyle(color: Colors.white54),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: Colors.greenAccent),
                      onPressed: setCustomTime,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                formatTime(),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isRunning ? null : startTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Start', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: isRunning ? stopTimer : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Stop', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: resetTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Reset', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
