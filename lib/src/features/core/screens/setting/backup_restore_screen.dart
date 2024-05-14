import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../repository/user_repository/user_repository.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({Key? key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  late SharedPreferences _prefs;
  bool _backupServiceEnabled = false;

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _backupServiceEnabled = _prefs.getBool('backupServiceEnabled') ?? false;
    });
  }

  Future<void> _toggleBackupService(bool value) async {
    setState(() {
      _backupServiceEnabled = value;
    });

    await _prefs.setBool('backupServiceEnabled', value);

    if (value) {
      print('backupServiceEnabled turned ON');

      /// is backupServiceEnabled on perform operation here
      AuthenticationRepository.instance.backupData();
      Get.snackbar(
        "Success",
        "Your data will be backup automatically after every 7 days.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        showProgressIndicator: true,
      );
    } else {
      print('backupServiceEnabled turned OFF');

      /// backupServiceEnabled turn of operations here
      await Workmanager().cancelByTag("backup");
      print("---> backup_data_service stopped successfully");
      Get.snackbar(
        "Success",
        "Automatic Backup has been stopped.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        showProgressIndicator: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Backup is encrypted and then stored in the database. We cannot see your data. Feel free to backup data.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Backup Data Automatically',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Switch(
                  value: _backupServiceEnabled,
                  onChanged: _toggleBackupService,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await UserRepository.saveDataToFirestore();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text("Backup Data"),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      UserRepository.restoreDataFromFirestore();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text("Restore Data"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
