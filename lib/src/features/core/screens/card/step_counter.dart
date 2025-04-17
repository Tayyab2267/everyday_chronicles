import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({super.key});

  @override
  _StepCounterState createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  // Define a list to keep track of active stream subscriptions
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];

  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double previousY = 0.0;
  double threshold = 5.0; // Adjust this threshold as needed
  int steps = 0;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _initializeAccelerometer();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.activityRecognition.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    }
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    }
  }

  void _initializeAccelerometer() {
    StreamSubscription<AccelerometerEvent>? subscription;
    subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!mounted) {
        // Check if the widget is still mounted before updating the state
        subscription?.cancel(); // Cancel the listener if the widget is disposed
        return;
      }
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;

        // Detect steps based on changes in acceleration
        detectStep(y);
      });
    });
    // Add the subscription to the list of subscriptions
    _streamSubscriptions.add(subscription);
  }

  void detectStep(double currentY) {
    // Check if the current acceleration crossed the threshold and is moving in the positive direction
    if (currentY > threshold && previousY < threshold) {
      steps++;
    }
    previousY = currentY;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _requestPermissions,
            child: const Text('Request Permission'),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text(
          "Steps: $steps",
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
