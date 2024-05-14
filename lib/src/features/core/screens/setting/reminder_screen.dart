import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late SharedPreferences _prefs;

  bool _prayerServiceEnabled = false;
  bool _moodServiceEnabled = false;
  bool _generalNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prayerServiceEnabled = _prefs.getBool('prayerServiceEnabled') ?? false;
      _moodServiceEnabled = _prefs.getBool('moodServiceEnabled') ?? false;
      _generalNotificationEnabled = _prefs.getBool('generalNotificationEnabled') ?? false;
    });
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

  Future<void> _toggleGeneralNotification(bool value) async {
    setState(() {
      _generalNotificationEnabled = value;
    });

    await _prefs.setBool('generalNotificationEnabled', value);

    if (value) {
      print('General Notification turned ON');
    } else {
      print('General Notification turned OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
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
                    'Mood Notification',
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
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Prayers Notification (MUSLIM)',
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
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'General Notifications',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _generalNotificationEnabled,
                  onChanged: _toggleGeneralNotification,
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

