import 'dart:convert';
import 'dart:math';
import 'package:everyday_chronicles/src/features/core/screens/card/AppUsageTime.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:usage_stats/usage_stats.dart';
import '../../../../constants/colors.dart';
import '../../controllers/sql_helper.dart';
import 'circle_painter_end.dart';
import 'circle_painter_start.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({
    super.key,
    required this.cardIcon,
    required this.cardDate,
    required this.cardTitle,
    required this.cardSubTitle,
    required this.color,
  });

  final IconData cardIcon;
  final String cardDate, cardTitle, cardSubTitle;
  final Color color;

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {

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

  void addNewMessageData(IconData iconData, String time, String address, String body, String msgOrWeather,
      Function onPressed) {
    setState(() {
      rowData.add({
        'icon': iconData,
        'time': time,
        'address': address,
        'body': body,
        'msgOrWeather': msgOrWeather,
        'onPressed': onPressed
      });
    });
  }

  // message code start
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> inboxMessages = [];

  Future<void> fetchInboxMessages() async {
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
      addNewMessageData(
          Icons.message, // Icon for SMS message
          messageTime,
          messageAddress, // Format the date to display only time (HH:mm)
          messageBody, // Format the date to display only time (HH:mm)
          "message",
          () {
      });
    }
  }

  Future<void> fetchMobileUsageTime() async {
    List<UsageInfo> usageStats = [];

    DateTime selectedDate = DateFormat('MMM dd, yyyy').parse(widget.cardDate);
    DateTime startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endDate = startDate.add(const Duration(days: 1));

    // grant usage permission - opens Usage Settings
    UsageStats.grantUsagePermission();
    // check if permission is granted

    bool? isPermission = await UsageStats.checkUsagePermission();

    if (isPermission!) {
      // query usage stats
      List<UsageInfo> stats = await UsageStats.queryUsageStats(startDate, endDate);
      setState(() {
        // Filter out apps with 0 minutes of usage time and sort by usage time in descending order
        usageStats = stats.where((usage) => getMinutes(usage.totalTimeInForeground) > 0).toList()
          ..sort((a, b) => getMinutes(b.totalTimeInForeground).compareTo(getMinutes(a.totalTimeInForeground)));
        // Save only top 3 apps
        usageStats = usageStats.sublist(0, min(3, usageStats.length));
      });

      // Call addNewMessageData for each of the top 3 apps
      for (int i = 0; i < usageStats.length; i++) {
        UsageInfo usage = usageStats[i];
        addNewMessageData(
          FontAwesomeIcons.mobileScreen, // Phone icon
          '23:59', // Time
          usage.packageName!, // App name
          '${getMinutes(usage.totalTimeInForeground)} min', // Usage time
          'mobileUsage',
              () {},
        );
        print("---> Inserted ...");
      }
    } else {
      UsageStats.grantUsagePermission();
    }
  }


  // Future<void> fetchMobileUsageTime() async {
  //   List<UsageInfo> usageStats = [];
  //
  //   DateTime selectedDate = DateFormat('MMM dd, yyyy').parse(widget.cardDate);
  //   DateTime startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  //   DateTime endDate = startDate.add(const Duration(days: 1));
  //
  //   // grant usage permission - opens Usage Settings
  //   UsageStats.grantUsagePermission();
  //   // check if permission is granted
  //   bool? isPermission = await UsageStats.checkUsagePermission();
  //
  //   if (isPermission!) {
  //     // query usage stats
  //     List<UsageInfo> stats = await UsageStats.queryUsageStats(startDate, endDate);
  //     setState(() {
  //       // Filter out apps with 0 minutes of usage time
  //       usageStats = stats.where((usage) => getMinutes(usage.totalTimeInForeground) > 0).toList();
  //     });
  //   } else {
  //     UsageStats.grantUsagePermission();
  //   }
  //
  // }

  // Helper function to convert milliseconds to minutes
  int getMinutes(String? totalTimeInForeground) {
    int milliseconds = int.tryParse(totalTimeInForeground!) ?? 0;
    return (milliseconds / (1000 * 60)).round();
  }

  Future<void> fetchWeatherData() async {
    String? requiredWeatherList = await SQLHelper.getWeatherListByDate(widget.cardDate);

    if (requiredWeatherList != null && requiredWeatherList.isNotEmpty) {
      List<dynamic> weatherDataList = jsonDecode(requiredWeatherList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < weatherDataList.length; i += 4) {
        String weatherTime = weatherDataList[i];
        String cityName = weatherDataList[i + 1];
        String condition = weatherDataList[i + 2];
        String temperature = weatherDataList[i + 3].toString();

        IconData weatherIcon = getWeatherIcon(condition);

        // Add weather data to rowData list
        addNewMessageData(
          weatherIcon, // Weather icon based on condition
          weatherTime, // Time
          cityName, // City name or any other appropriate text
          temperature, // Body
          'weather',
              () {},
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

  @override
  void initState() {
    fetchInboxMessages();
    fetchWeatherData();
    fetchMobileUsageTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Sort the rowData list before displaying
    sortRowDataByTime();
    final Color timeBackgroundColor = Get.isDarkMode ? color3 : Colors.grey;
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
            color: widget.color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(widget.cardIcon, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // shows circle pointer start
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: timeBackgroundColor,
                    ),
                    height: 35,
                    width: 70,
                    child: CustomPaint(
                      painter: CirclePainterStart(),
                    ),
                  ),
                  // Dynamically generate rows using rowData list
                  for (var data in rowData)
                    _buildRow(
                      data['icon'],
                      data['time'],
                      data['address'],
                      data['body'],
                      data['msgOrWeather'],
                      timeBackgroundColor,
                      data['onPressed'],
                    ),
                  // shows circle end pointer
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: timeBackgroundColor,
                    ),
                    height: 35,
                    width: 70,
                    child: CustomPaint(
                      painter: CirclePainterEnd(),
                    ),
                  ),
                ],
              ),
            ),
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
                //Get.to(() => const CardTraditionalScreen());
                //Get.to(() => const WeatherPage());
                /// Delete Weather Page
                Get.to(() => MobileUsageTime(cardDate: widget.cardDate));

              },
              backgroundColor: color1,
              tooltip: "Opens Traditional Page",
              child:
                  const FaIcon(FontAwesomeIcons.bookOpen, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData iconData, String time, String address, String body, String msgOrWeather,
      Color backgroundColor, Function onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10, left: 0),
          height: 70,
          width: 70,
          color: backgroundColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const VerticalDivider(
                color: Colors.black,
                thickness: 2,
              ),
              Container(
                color: backgroundColor,
                child: Text(
                  time,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(iconData),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                if (msgOrWeather == 'message') {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                    title: Text("Sender: $address\nTime: $time"),
                    contentPadding: const EdgeInsets.all(20.0),
                    content: Text(
                      "Message: $body",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                } else if (msgOrWeather == 'weather') {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                    title: Text("City Name: $address\nTime: $time\nTemperature: $body"),
                    contentPadding: const EdgeInsets.all(20.0),
                    content: Icon(
                      iconData,
                      size: 60,
                    ),
                  );
                } else if (msgOrWeather == 'mobileUsage') {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                    title: Text("Usage Time: $body"),
                    contentPadding: const EdgeInsets.all(20.0),
                    content: Text("App Name: $address"),
                  );
                }
                // Default return statement
                return const SizedBox.shrink(); // or any other default Widget
              },
            );
            onPressed(); // Call the provided onPressed function
          },
          iconSize: 30,
        ),
      ],
    );
  }

}
