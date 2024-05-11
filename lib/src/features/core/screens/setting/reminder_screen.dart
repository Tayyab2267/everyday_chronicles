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
  bool _prayerNotificationEnabled = true;
  bool _moodNotificationEnabled = true;
  bool _generalNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prayerNotificationEnabled = _prefs.getBool('prayerNotificationEnabled') ?? true;
      _moodNotificationEnabled = _prefs.getBool('moodNotificationEnabled') ?? true;
      _generalNotificationEnabled = _prefs.getBool('generalNotificationEnabled') ?? true;
    });
  }

  Future<void> _togglePrayerNotification(bool value) async {
    setState(() {
      _prayerNotificationEnabled = value;
    });

    await _prefs.setBool('prayerNotificationEnabled', value);

    if (value) {
      print('Prayer Notification turned ON');
      AuthenticationRepository().fajarPrayer();
      AuthenticationRepository().zuharPrayer();
      AuthenticationRepository().asarPrayer();
      AuthenticationRepository().maghribPrayer();
      AuthenticationRepository().ishaPrayer();
    } else {
      print('Prayer Notification turned OFF');
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
      // Cancel other prayer services
    }
  }

  Future<void> _toggleMoodNotification(bool value) async {
    setState(() {
      _moodNotificationEnabled = value;
    });

    await _prefs.setBool('moodNotificationEnabled', value);

    if (value) {
      print('Mood Notification turned ON');
      AuthenticationRepository().moodService();
    } else {
      print('Mood Notification turned OFF');
      await Workmanager().cancelByTag("mood");
      print("---> mood_service stopped successfully");
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
                  value: _moodNotificationEnabled,
                  onChanged: _toggleMoodNotification,
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
                  value: _prayerNotificationEnabled,
                  onChanged: _togglePrayerNotification,
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

