import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:workmanager/workmanager.dart';

class CustomizeScreen extends StatefulWidget {
  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.locationAlways.request();
    if (status == PermissionStatus.granted) {
      // Permission granted, proceed with your app logic
      print('Location permission allowed all the time');
    } else if (status == PermissionStatus.denied) {
      // Permission denied, handle accordingly
      print('Location permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied, request users to enable it from settings
      print('Location permission permanently denied');
      openAppSettings();
    }

    // For local notifications permission, you might need to handle it separately
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    bool? notificationsResult = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    print("Notification Permission Allowed or Not: $notificationsResult");
  }

  late SharedPreferences _prefs;
  bool _moodServiceEnabled = false;
  bool _weatherServiceEnabled = false;
  bool _locationServiceEnabled = false;
  bool _mobileUsageServiceEnabled = false;
  bool _messageServiceEnabled = false;
  bool _callLocationServiceEnabled = false;
  bool _prayerServiceEnabled = false;

  @override
  void initState() {
    _loadPreferences();
    super.initState();
    requestLocationPermission();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _moodServiceEnabled = _prefs.getBool('moodServiceEnabled') ?? false;
      _weatherServiceEnabled = _prefs.getBool('weatherServiceEnabled') ?? false;
      _locationServiceEnabled = _prefs.getBool('locationServiceEnabled') ?? false;
      _mobileUsageServiceEnabled = _prefs.getBool('mobileUsageServiceEnabled') ?? false;
      _messageServiceEnabled = _prefs.getBool('messageServiceEnabled') ?? false;
      _callLocationServiceEnabled = _prefs.getBool('callLocationServiceEnabled') ?? false;
      _prayerServiceEnabled = _prefs.getBool('prayerServiceEnabled') ?? false;
    });
  }

  Future<void> _toggleMoodService(bool value) async {
    setState(() {
      _moodServiceEnabled = value;
    });
    await _prefs.setBool('moodServiceEnabled', value);
    if (value) {
      print('Mood Service turned ON');
      AuthenticationRepository().moodService();
    } else {
      print('Mood Service turned OFF');
      Workmanager().cancelByTag("mood");
    }
  }
  Future<void> _toggleWeatherService(bool value) async {
    setState(() {
      _weatherServiceEnabled = value;
    });
    await _prefs.setBool('weatherServiceEnabled', value);
    if (value) {
      print('Weather Service turned ON');
      AuthenticationRepository().weatherService();
    } else {
      print('Weather Service turned OFF');
      Workmanager().cancelByTag("weather");
    }
  }
  Future<void> _toggleLocationService(bool value) async {
    setState(() {
      _locationServiceEnabled = value;
    });
    await _prefs.setBool('locationServiceEnabled', value);
    if (value) {
      print('Location Service turned ON');
      AuthenticationRepository().userLocationService();
    } else {
      print('Location Service turned OFF');
      Workmanager().cancelByTag("user");
    }
  }
  Future<void> _toggleMobileUsageService(bool value) async {
    setState(() {
      _mobileUsageServiceEnabled = value;
    });
    await _prefs.setBool('mobileUsageServiceEnabled', value);
    if (value) {
      print('Mobile Usage Service turned ON');
      // Grant usage permission
      UsageStats.grantUsagePermission();
      await _prefs.setBool('mobileUsageServiceEnabled', true);
    } else {
      print('Mobile Usage Service turned OFF');
      await _prefs.setBool('mobileUsageServiceEnabled', false);
    }
  }
  Future<void> _toggleMessageService(bool value) async {
    setState(() {
      _messageServiceEnabled = value;
    });
    await _prefs.setBool('messageServiceEnabled', value);
    if (value) {
      print('Message Service turned ON');
      await _prefs.setBool('messageServiceEnabled', true);
    } else {
      print('Message Service turned OFF');
      await _prefs.setBool('messageServiceEnabled', false);
    }
  }
  Future<void> _toggleCallLocationService(bool value) async {
    setState(() {
      _callLocationServiceEnabled = value;
    });
    await _prefs.setBool('callLocationServiceEnabled', value);
    if (value) {
      print('Call Location Service turned ON');
      AuthenticationRepository().callLocationService();
    } else {
      print('Call Location Service turned OFF');
      Workmanager().cancelByTag("call");
    }
  }
  Future<void> _togglePrayerService(bool value) async {
    setState(() {
      _prayerServiceEnabled = value;
    });
    await _prefs.setBool('prayerServiceEnabled', value);
    if (value) {
      print('Prayer Service turned ON');
      AuthenticationRepository().fajarPrayer();
      AuthenticationRepository().zuharPrayer();
      AuthenticationRepository().asarPrayer();
      AuthenticationRepository().maghribPrayer();
      AuthenticationRepository().ishaPrayer();
    } else {
      /// service off logic
      print('Prayer Service turned OFF');
      await Workmanager().cancelByTag("fajar");
      print("---> fajar_prayer_service stopped successfully");
      await Workmanager().cancelByTag("zuhar");
      print("---> zuhar_prayer_service stopped successfully");
      await Workmanager().cancelByTag("asar");
      print("---> asar_prayer_service stopped successfully");
      await Workmanager().cancelByTag("maghrib");
      print("---> maghrib_prayer_service stopped successfully");
      await Workmanager().cancelByTag("isha");
      print("---> isha_prayer_service stopped successfully");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Customization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Mood AI Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _moodServiceEnabled,
                  onChanged: _toggleMoodService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Weather Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _weatherServiceEnabled,
                  onChanged: _toggleWeatherService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Location Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _locationServiceEnabled,
                  onChanged: _toggleLocationService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Mobile Usage Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _mobileUsageServiceEnabled,
                  onChanged: _toggleMobileUsageService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Messages Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _messageServiceEnabled,
                  onChanged: _toggleMessageService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Calls with location Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _callLocationServiceEnabled,
                  onChanged: _toggleCallLocationService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Prayer Service',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _prayerServiceEnabled,
                  onChanged: _togglePrayerService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

