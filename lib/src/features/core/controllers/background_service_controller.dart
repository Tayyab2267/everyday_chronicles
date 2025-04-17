import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_apps/device_apps.dart';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/repository/user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:telephony/telephony.dart';
import 'package:usage_stats/usage_stats.dart';

import 'noti.dart';

class BackgroundServiceController extends GetxController {
  static BackgroundServiceController get instance => Get.find();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<Map<String, dynamic>> rowDataText = [];

  /// Text will send to server to fetch Mood
  Future<String> sendTextToPredictEmotion(String text) async {
    var url = 'http://192.168.0.113:5001/predict-emotion';
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['predicted_emotion'];
    } else {
      throw Exception('Failed to send text to Flask');
    }
  }

  ///Sort the Text by time
  void sortRowDataByTime() {
    rowDataText.sort((a, b) {
      // Parse time strings to DateTime objects for comparison
      DateTime timeA = DateFormat('HH:mm').parse(a['time']);
      DateTime timeB = DateFormat('HH:mm').parse(b['time']);
      // Compare the times
      return timeA.compareTo(timeB);
    });
  }

  void addNewString(String time, String text) {
    rowDataText.add({
      'time': time,
      'text': text,
    });
  }

  /// Fetch Message
  // message code start
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> inboxMessages = [];

  Future<void> fetchInboxMessages() async {
    DateTime cardDate = DateFormat('MMM dd, yyyy').parse(getCurrentDate());
    DateTime startDate = DateTime(cardDate.year, cardDate.month, cardDate.day);
    DateTime endDate = startDate.add(const Duration(days: 1));

    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      filter: SmsFilter.where(SmsColumn.DATE)
          .greaterThan(startDate.millisecondsSinceEpoch.toString())
          .and(SmsColumn.DATE)
          .lessThan(endDate.millisecondsSinceEpoch.toString()),
      sortOrder: [
        OrderBy(SmsColumn.DATE, sort: Sort.ASC),
        OrderBy(SmsColumn.BODY)
      ],
    );

    inboxMessages = messages;

    for (var message in inboxMessages) {
      String messageTime = DateFormat('HH:mm').format(
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(message.date.toString())));
      String messageAddress = message.address!;
      String messageBody = message.body!;

      // Text Code below
      String messageText =
          'You have received a message("$messageBody") at "$messageTime" from ($messageAddress).';
      addNewString(
        messageTime, // time
        messageText, // text
      );
    }
  }

  int getMinutes(String? totalTimeInForeground) {
    int milliseconds = int.tryParse(totalTimeInForeground!) ?? 0;
    return (milliseconds / (1000 * 60)).round();
  }

  Future<void> fetchMobileUsageTime() async {
    List<UsageInfo> usageStats = [];

    DateTime selectedDate = DateFormat('MMM dd, yyyy').parse(getCurrentDate());
    DateTime startDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endDate = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 0);

    print("---> Selected Date: ${selectedDate.toString()}");
    print("---> Start Date: ${startDate.toString()}");
    print("---> End Date: ${endDate.toString()}");

    // Grant usage permission
    UsageStats.grantUsagePermission();

    // Check if permission is granted
    bool? isPermission = await UsageStats.checkUsagePermission();

    if (isPermission != null && isPermission) {
      // Get apps with launch intents
      List<Application> installedApps =
          await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
      );
      List<String> appPackageNames =
          installedApps.map((app) => app.packageName).toList();

      // Query usage stats for all packages within the date range
      List<UsageInfo> stats =
          await UsageStats.queryUsageStats(startDate, endDate);

      // Filter out apps with 0 minutes of usage time
      List<UsageInfo> filteredStats = stats
          .where((usage) => getMinutes(usage.totalTimeInForeground) > 0)
          .toList();

      // Filter by app package names (optional, if needed for additional security)
      filteredStats = filteredStats
          .where((usage) => appPackageNames.contains(usage.packageName!))
          .toList();

      // Group by package name and sum usage time
      Map<String, int> usageMap = {};
      for (UsageInfo usage in filteredStats) {
        usageMap[usage.packageName!] = (usageMap[usage.packageName!] ?? 0) +
            getMinutes(usage.totalTimeInForeground);
      }

      // Sort apps by usage time in descending order
      List<MapEntry<String, int>> sortedMap = usageMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Select top 3 packages and corresponding usage info
      usageStats = sortedMap
          .take(3)
          .map((entry) => filteredStats
              .firstWhere((usage) => usage.packageName == entry.key))
          .toList();

      // Call addNewMessageData for each of the top 3 apps
      for (int i = 0; i < usageStats.length; i++) {
        UsageInfo usage = usageStats[i];
        String appName = '';
        try {
          Application? app = await DeviceApps.getApp(usage.packageName!);
          appName = app!.appName;
          print("---> App Name: $appName ...");
        } catch (ex) {
          print("--> ex: ${ex.toString()} ...");
        }

        //Text code below
        String usageTime = getMinutes(usage.totalTimeInForeground).toString();
        String text = 'You have used $appName for around $usageTime min.';
        addNewString(
          '23:59', // Time
          text, // text
        );
      }
    } else {
      UsageStats.grantUsagePermission();
    }
  }

  Future<void> fetchWeatherData() async {
    String? requiredWeatherList =
        await SQLHelper.getWeatherListByDate(getCurrentDate());

    if (requiredWeatherList!.isNotEmpty) {
      List<dynamic> weatherDataList = jsonDecode(requiredWeatherList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < weatherDataList.length; i += 4) {
        String weatherTime = weatherDataList[i];
        String cityName = weatherDataList[i + 1];
        String condition = weatherDataList[i + 2];
        String temperature = weatherDataList[i + 3].toString();

        IconData weatherIcon = getWeatherIcon(condition);

        // text code below
        String text =
            'The weather condition is $condition and "$temperature"C  at "$weatherTime".';
        addNewString(
          weatherTime, // Time
          text, // text
        );
      }
    }
  }

  IconData getWeatherIcon(String condition) {
    // Map weather conditions to appropriate icons
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Icons.beach_access;
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return Icons.cloud;
      case 'thunderstorm':
        return FontAwesomeIcons.cloudBolt;
      default:
        return FontAwesomeIcons.solidSun;
    }
  }

  Future<void> fetchUserLocationData() async {
    String? requiredUserLocationList =
        await SQLHelper.getUserLocationListByDate(getCurrentDate());

    if (requiredUserLocationList!.isNotEmpty) {
      List<dynamic> userLocationDataList = jsonDecode(requiredUserLocationList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < userLocationDataList.length; i += 3) {
        String locationTime = userLocationDataList[i];
        String locationLat = userLocationDataList[i + 1];
        String locationLong = userLocationDataList[i + 2];

        // String? locationAddress = placemarks[0].name;
        print("location Time = $locationTime");
        print("location Lat = $locationLat");
        print("location Long = $locationLong");
        // print("location Address = $locationAddress");
        print("================================");

        //Text code below
        List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(locationLat),
          double.parse(locationLong),
        );
        String text = 'you are at "${placemarks[0].name}" at "$locationTime".';
        addNewString(
          locationTime, // Time
          text, // Text
        );
      }
    }
  }

  Future<void> fetchCallLocationData() async {
    print("fetching Call Location Data .........");
    String? requiredCallLocationList =
        await SQLHelper.getCallLocationListByDate(getCurrentDate());

    if (requiredCallLocationList!.isNotEmpty) {
      List<dynamic> callLocationDataList = jsonDecode(requiredCallLocationList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < callLocationDataList.length; i += 5) {
        String callTime = callLocationDataList[i].toString();
        String callNumber = callLocationDataList[i + 1].toString();
        String callLocationLat = callLocationDataList[i + 2].toString();
        String callLocationLong = callLocationDataList[i + 3].toString();
        String callName = callLocationDataList[i + 4].toString();

        print("================================");
        print("Call Time = $callTime");
        print("Call Number = $callNumber");
        print("Call Location Lat = $callLocationLat");
        print("Call Location Long = $callLocationLong");
        print("Call Name = $callName");
        print("================================");

        List<dynamic> sendDataList = [];
        sendDataList.add(callLocationLat);
        sendDataList.add(callLocationLong);
        sendDataList.add(callName);

        String? sendDataString = jsonEncode(sendDataList);

        // text code below
        List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(callLocationLat),
          double.parse(callLocationLong),
        );
        String text =
            'You have received call at "$callTime" from "$callName" and "$callNumber" at this "${placemarks[0].name}".';
        addNewString(
          callTime, // Time
          text, // Text
        );
      }
    } else {
      print("Call Location List is null.......");
    }
  }

  Future<void> fetchPrayerData() async {
    String? requiredPrayerList =
        await SQLHelper.getPrayerListByDate(getCurrentDate());

    if (requiredPrayerList!.isNotEmpty) {
      List<dynamic> prayerDataList = jsonDecode(requiredPrayerList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < prayerDataList.length; i += 2) {
        String prayerTime = prayerDataList[i];
        String prayerName = prayerDataList[i + 1];

        print("Prayer Time = $prayerTime");
        print("Prayer Name = $prayerName");
        print("================================");

        String text = 'You have offered "$prayerName Prayer" at "$prayerTime".';
        addNewString(
          prayerTime, // Time
          text, // Text
        );
      }
    }
  }

  Future<void> moodServiceMethod() async {
    print("-----> Fetching Mood here");

    String? userSelectMood =
        await SQLHelper.getUserSelectMoodByDate(getCurrentDate());

    ///Mood Logic here

    if (userSelectMood != "true") {
      await fetchInboxMessages();
      await fetchMobileUsageTime();
      await fetchWeatherData();
      await fetchUserLocationData();
      await fetchCallLocationData();
      await fetchPrayerData();

      sortRowDataByTime();

      String? subtitle = await SQLHelper.getSubtitleByDate(getCurrentDate());
      String? thoughts = await SQLHelper.getThoughtsByDate(getCurrentDate());

      print("Subtitle: $subtitle");
      print("Thoughts: $thoughts");

      String rowDataTextText =
          rowDataText.map((data) => "${data['text']}").join(' ');
      rowDataTextText += " $subtitle $thoughts";

      print("=====> TEXT: $rowDataTextText ==============");
      String moodFromText = await sendTextToPredictEmotion(rowDataTextText);
      print("========> Predicted Mood: $moodFromText =========");
      SQLHelper.updateMoodIconByDate(getCurrentDate(), moodFromText);

      //Show notification here
      Noti.showBigTextNotification(
          title: moodFromText,
          body: "Your today's mood is '$moodFromText'",
          fln: flutterLocalNotificationsPlugin);
    } else {
      print("user has select Mood don't need to analyze mood");
    }
  }

  Future<void> taskOneCreateDummyDayDataService() async {
    print("-----> Adding new data to localDatabase");
    try {
      print("-----> Before SQL Flite ");
      await SQLHelper.createItem(
        getCurrentDate(),
        "fantastic",
        "false",
        "Title of the day",
        "This is the dummy text",
        "this is dummy 3 am thoughts",
        "Here the summary will be displayed when user enter something inside 3am thoughts and daily doing",
      );
      print("-----> After SQL Flite");
    } catch (ex) {
      print("----> Ex: ${ex.toString()}");
    }
  }

  Future<void> fajarPrayerMethod() async {
    /// awesome_notification
    // await Noti.initializeNotification();
    await Noti.showNotification(
      title: "Prayer Checker",
      body: "Had you offered FAJAR Prayer?",
      payload: {
        'yes_action_key': 'yes', // for Yes button
        'no_action_key': 'no', // for No button
      },
      actionButtons: [
        NotificationActionButton(
          key: 'yes_fajar',
          label: 'Yes',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        ),
        NotificationActionButton(
          key: 'no_fajar',
          label: 'No',
          actionType: ActionType.SilentAction,
          color: Colors.red,
        ),
      ],
    );
  }

  Future<void> zuharPrayerMethod() async {
    await Noti.showNotification(
      title: "Prayer Checker",
      body: "Had you offered ZUHAR Prayer?",
      payload: {
        'yes_action_key': 'yes', // for Yes button
        'no_action_key': 'no', // for No button
      },
      actionButtons: [
        NotificationActionButton(
          key: 'yes_zuhar',
          label: 'Yes',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        ),
        NotificationActionButton(
          key: 'no_zuhar',
          label: 'No',
          actionType: ActionType.SilentAction,
          color: Colors.red,
        ),
      ],
    );
  }

  Future<void> asarPrayerMethod() async {
    await Noti.showNotification(
      title: "Prayer Checker",
      body: "Had you offered ASAR Prayer?",
      payload: {
        'yes_action_key': 'yes', // for Yes button
        'no_action_key': 'no', // for No button
      },
      actionButtons: [
        NotificationActionButton(
          key: 'yes_asar',
          label: 'Yes',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        ),
        NotificationActionButton(
          key: 'no_asar',
          label: 'No',
          actionType: ActionType.SilentAction,
          color: Colors.red,
        ),
      ],
    );
  }

  Future<void> maghribPrayerMethod() async {
    await Noti.showNotification(
      title: "Prayer Checker",
      body: "Had you offered MAGHRIB Prayer?",
      payload: {
        'yes_action_key': 'yes', // for Yes button
        'no_action_key': 'no', // for No button
      },
      actionButtons: [
        NotificationActionButton(
          key: 'yes_maghrib',
          label: 'Yes',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        ),
        NotificationActionButton(
          key: 'no_maghrib',
          label: 'No',
          actionType: ActionType.SilentAction,
          color: Colors.red,
        ),
      ],
    );
  }

  Future<void> ishaPrayerMethod() async {
    await Noti.showNotification(
      title: "Prayer Checker",
      body: "Had you offered ISHA Prayer?",
      payload: {
        'yes_action_key': 'yes', // for Yes button
        'no_action_key': 'no', // for No button
      },
      actionButtons: [
        NotificationActionButton(
          key: 'yes_isha',
          label: 'Yes',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        ),
        NotificationActionButton(
          key: 'no_isha',
          label: 'No',
          actionType: ActionType.SilentAction,
          color: Colors.red,
        ),
      ],
    );
  }

  Future<void> backupMethod() async {
    await UserRepository.saveDataToFirestore();
    //Show notification here
    Noti.showBigTextNotification(
        title: "Backup Data",
        body: "Your Data has been backup.",
        fln: flutterLocalNotificationsPlugin);
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();
    return presentDate.toString();
  }
}
