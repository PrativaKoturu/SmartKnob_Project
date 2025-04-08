import 'package:flutter/material.dart';

class VolumeControlScreen extends StatefulWidget {
  const VolumeControlScreen({super.key});

  @override
  State<VolumeControlScreen> createState() => _VolumeControlScreenState();
}

class _VolumeControlScreenState extends State<VolumeControlScreen> {
  double focusVolume = 0.5;
  double shortBreakVolume = 0.5;
  double longBreakVolume = 0.5;

  bool muteAll = false;
  bool doNotDisturb = false;
  bool adaptiveSound = false;

  Widget buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1B4079),
          ),
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0,
          max: 1,
          divisions: 10,
          label: "${(value * 100).round()}%",
          activeColor: Color(0xFF4D7C8A),
          inactiveColor: Color(0xFF8FAD88),
          thumbColor: Color(0xFFCBDF90),
        ),
      ],
    );
  }

  Widget buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B4079),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFFCBDF90),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7F9C96),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Volume Control Mode",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4079),
                ),
              ),
              const SizedBox(height: 30),
              buildSlider("Focus Session Volume", focusVolume, (val) {
                setState(() => focusVolume = val);
              }),
              buildSlider("Short Break Volume", shortBreakVolume, (val) {
                setState(() => shortBreakVolume = val);
              }),
              buildSlider("Long Break Volume", longBreakVolume, (val) {
                setState(() => longBreakVolume = val);
              }),
              const SizedBox(height: 30),
              buildToggle("Mute All Sounds", muteAll, (val) {
                setState(() => muteAll = val);
              }),
              buildToggle("Do Not Disturb Mode", doNotDisturb, (val) {
                setState(() => doNotDisturb = val);
              }),
              buildToggle("AI Adaptive Sound", adaptiveSound, (val) {
                setState(() => adaptiveSound = val);
              }),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Save settings logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCBDF90),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    "Save Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4079),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
