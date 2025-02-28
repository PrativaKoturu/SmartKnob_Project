import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/start_button.dart';
import '../widgets/input_field.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _timeController = TextEditingController();
  int remainingTime = 0;
  Timer? _timer;

  void _startTimer() async {
    int time = int.tryParse(_timeController.text) ?? 0;
    if (time > 0) {
      await ApiService.setTimer(time);
      setState(() {
        remainingTime = time;
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Focus Timer",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                InputField(controller: _timeController),
                const SizedBox(height: 20),
                StartButton(onPressed: _startTimer),
                const SizedBox(height: 30),
                CountdownTimer(remainingTime: remainingTime),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
