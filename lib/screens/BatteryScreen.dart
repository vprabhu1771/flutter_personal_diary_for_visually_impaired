import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryScreen extends StatefulWidget {

  final String title;

  const BatteryScreen ({super.key,  required this.title });

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {

  Battery _battery = Battery();
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  // Method to get the battery level
  Future<void> _getBatteryLevel() async {
    int level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'Battery Level: $_batteryLevel%',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}