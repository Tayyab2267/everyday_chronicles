import 'dart:convert';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:usage_stats/usage_stats.dart';
import '../../../../constants/colors.dart';
import '../../controllers/sql_helper.dart';

class CardTraditionalScreen extends StatefulWidget {
  const CardTraditionalScreen({
    super.key,
    required this.cardIcon,
    required this.cardDate,
    required this.cardID,
    required this.cardTitle,
    required this.cardSubTitle,
  });

  final IconData cardIcon;
  final String cardID, cardDate, cardTitle, cardSubTitle;

  @override
  State<CardTraditionalScreen> createState() => _CardTraditionalScreenState();
}

class _CardTraditionalScreenState extends State<CardTraditionalScreen> {
  // Define list of data for rows
  final List<Map<String, dynamic>> rowData = [];

  /// This method to compare times and sort the rowData list
  void sortRowDataByTime() {
    rowData.sort((a, b) {
      // Parse time strings to DateTime objects for comparison
      DateTime timeA = DateFormat('HH:mm').parse(a['time']);
      DateTime timeB = DateFormat('HH:mm').parse(b['time']);
      // Compare the times
      return timeA.compareTo(timeB);
    });
  }

  void addNewString(String time, String text) {
    setState(() {
      rowData.add({
        'time': time,
        'text': text,
      });
    });
  }

  Future<void> fetchInboxMessages() async {
    // message code start
    final Telephony telephony = Telephony.instance;
    List<SmsMessage> inboxMessages = [];

    DateTime cardDate = DateFormat('MMM dd, yyyy').parse(widget.cardDate);
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

    setState(() {
      inboxMessages = messages;
    });

    for (var message in inboxMessages) {
      String messageTime = DateFormat('HH:mm').format(
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(message.date.toString())));
      String messageAddress = message.address!;
      String messageBody = message.body!;

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

    DateTime selectedDate = DateFormat('MMM dd, yyyy').parse(widget.cardDate);
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

    if (isPermission!) {
      // Get apps with launch intents
      List<Application> installedApps =
          await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
      );
      List<String> appPackageNames =
          installedApps.map((app) => app.packageName!).toList();

      // Query usage stats for all packages within the date range
      List<UsageInfo> stats =
          await UsageStats.queryUsageStats(startDate, endDate);

      setState(() {
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
      });

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

        String usageTime = getMinutes(usage.totalTimeInForeground).toString();
        String text = 'You have used $appName for around $usageTime min.';
        addNewString(
          '23:59', // Time
          text, // text
        );
        print("---> Inserted ...");
      }
    } else {
      UsageStats.grantUsagePermission();
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
  Future<void> fetchWeatherData() async {
    String? requiredWeatherList =
        await SQLHelper.getWeatherListByDate(widget.cardDate);

    if (requiredWeatherList != null && requiredWeatherList.isNotEmpty) {
      List<dynamic> weatherDataList = jsonDecode(requiredWeatherList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < weatherDataList.length; i += 4) {
        String weatherTime = weatherDataList[i];
        String cityName = weatherDataList[i + 1];
        String condition = weatherDataList[i + 2];
        String temperature = weatherDataList[i + 3].toString();

        IconData weatherIcon = getWeatherIcon(condition);

        String text =
            'The weather condition is $condition and "$temperature"C  at "$weatherTime".';
        // Add weather data to rowData list

        addNewString(
          weatherTime, // Time
          text, // text
        );
      }
    }
  }

  Future<void> fetchUserLocationData() async {
    String? requiredUserLocationList =
        await SQLHelper.getUserLocationListByDate(widget.cardDate);

    if (requiredUserLocationList != null &&
        requiredUserLocationList.isNotEmpty) {
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

        List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(locationLat),
          double.parse(locationLong),
        );

        String text = 'you are at "${placemarks[0].name}" at "$locationTime".';
        // Add user location data to rowData list
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
    await SQLHelper.getCallLocationListByDate(widget.cardDate);

    if (requiredCallLocationList != null &&
        requiredCallLocationList.isNotEmpty) {
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

        List<Placemark> placemarks = await placemarkFromCoordinates(
          double.parse(callLocationLat),
          double.parse(callLocationLong),
        );

        List<dynamic> sendDataList = [];
        sendDataList.add(callLocationLat);
        sendDataList.add(callLocationLong);
        sendDataList.add(callName);

        String? sendDataString = jsonEncode(sendDataList);

        String text = 'You have received call at "$callTime" from "$callName" and "$callNumber" at this "${placemarks[0].name}".';
        // Add user location data to rowData list
        addNewString(
          callTime, // Time
          text, // Text
        );
      }
    } else {
      print("Call Location List is null.......");
    }
  }

  @override
  void initState() {
    fetchInboxMessages();
    fetchMobileUsageTime();
    fetchWeatherData();
    fetchUserLocationData();
    fetchCallLocationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Sort the rowData list before displaying
    sortRowDataByTime();
    const String paraTrad =
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.";

    // Concatenate rowData strings
    String rowDataText = rowData.map((data) => "${data['text']}").join(' ');

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        title: Text(widget.cardDate),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(widget.cardIcon, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 80, left: 20, right: 20),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   paraTrad,
              //   textAlign: TextAlign.justify,
              //   style: Theme.of(context)
              //       .textTheme
              //       .titleSmall
              //       ?.copyWith(fontSize: 20.0),
              // ),
              Text(
                rowDataText,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              onPressed: () {
                Get.back();
              },
              backgroundColor: color1,
              tooltip: "Close Traditional Page",
              child: const FaIcon(FontAwesomeIcons.book, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
