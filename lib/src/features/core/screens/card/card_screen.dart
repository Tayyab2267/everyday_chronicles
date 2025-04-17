import 'dart:convert';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:everyday_chronicles/src/features/core/screens/card/card_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:usage_stats/usage_stats.dart';
import '../../../../constants/colors.dart';
import '../../controllers/sql_helper.dart';
import '../home/bottom_navigation_bar_widget.dart';
import 'card_traditional_screen.dart';
import 'circle_painter_end.dart';
import 'circle_painter_start.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CardScreen extends StatefulWidget {
  const CardScreen({
    super.key,
    required this.cardIcon,
    required this.cardDate,
    required this.cardID,
    required this.cardTitle,
    required this.cardSubTitle,
    required this.cardThought,
    required this.color,
  });

  final IconData cardIcon;
  final String cardID, cardDate, cardTitle, cardSubTitle, cardThought;
  final Color color;

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  // Define list of data for rows
  final List<Map<String, dynamic>> rowData = [];
  final List<Map<String, dynamic>> rowDataText = [];

  // /// Mood AI Model Function
  // Future<String> sendTextToPredictEmotion(String text) async {
  //   // var url = 'http://127.0.0.1:5001/predict-emotion';
  //   var url = 'http://192.168.0.113:5001/predict-emotion';
  //   var response = await http.post(Uri.parse(url),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"text": text}));
  //
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body)['predicted_emotion'];
  //   } else {
  //     throw Exception('Failed to send text to Flask');
  //   }
  // }

  /// Mood AI Model Function
  Future<String> sendTextToSummary(String text) async {
    // var url = 'http://127.0.0.1:5001/predict-emotion';
    var url = 'http://192.168.0.113:5001/summarize-text';
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['summary'];
    } else {
      throw Exception('Failed to send text to Flask');
    }
  }

  /// This method to compare times and sort the rowData list
  void sortRowDataByTime() {
    rowData.sort((a, b) {
      // Parse time strings to DateTime objects for comparison
      DateTime timeA = DateFormat('HH:mm').parse(a['time']);
      DateTime timeB = DateFormat('HH:mm').parse(b['time']);
      // Compare the times
      return timeA.compareTo(timeB);
    });
    rowDataText.sort((a, b) {
      // Parse time strings to DateTime objects for comparison
      DateTime timeA = DateFormat('HH:mm').parse(a['time']);
      DateTime timeB = DateFormat('HH:mm').parse(b['time']);
      // Compare the times
      return timeA.compareTo(timeB);
    });
  }

  void addNewString(String time, String text) {
    setState(() {
      rowDataText.add({
        'time': time,
        'text': text,
      });
    });
  }

  void addNewMessageData(IconData iconData, String time, String address,
      String body, String msgOrWeather, Function onPressed) {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool messageServiceEnabled =
        prefs.getBool('messageServiceEnabled') ?? false;
    print('Message Service Enabled: $messageServiceEnabled');

    if (messageServiceEnabled == true) {
      DateTime cardDate = DateFormat('MMM dd, yyyy').parse(widget.cardDate);
      DateTime startDate =
          DateTime(cardDate.year, cardDate.month, cardDate.day);
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
            Icons.message,
            // Icon for SMS message
            messageTime,
            messageAddress,
            // Format the date to display only time (HH:mm)
            messageBody,
            // Format the date to display only time (HH:mm)
            "message",
            () {});

        // Text Code below
        String messageText =
            'You have received a message("$messageBody") at "$messageTime" from ($messageAddress).';
        addNewString(
          messageTime, // time
          messageText, // text
        );
      }
    } else {
      print("Message Service is not enabled from setting");
    }
  }

  Future<void> fetchMobileUsageTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool mobileUsageServiceEnabled =
        prefs.getBool('mobileUsageServiceEnabled') ?? false;
    print('Mobile Usage Service Enabled: $mobileUsageServiceEnabled');

    if (mobileUsageServiceEnabled == true) {
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

          addNewMessageData(
            FontAwesomeIcons.mobileScreen, // Phone icon
            '23:59', // Time
            appName, // App name
            '${getMinutes(usage.totalTimeInForeground)} min', // Usage time
            'mobileUsage',
            () {},
          );
          print("---> Inserted ...");

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
    } else {
      print("Mobile Usage Service is Off");
    }
  }

  int getMinutes(String? totalTimeInForeground) {
    int milliseconds = int.tryParse(totalTimeInForeground!) ?? 0;
    return (milliseconds / (1000 * 60)).round();
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

        // Add weather data to rowData list
        addNewMessageData(
          weatherIcon, // Weather icon based on condition
          weatherTime, // Time
          cityName, // City name or any other appropriate text
          temperature, // Body
          'weather',
          () {},
        );

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

        // Add user location data to rowData list
        addNewMessageData(
          FontAwesomeIcons.locationPin, // Weather icon based on condition
          locationTime, // Time
          locationLat, // address
          locationLong, // Body
          'userLocation',
          () {},
        );

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

  Future<void> fetchPrayerData() async {
    String? requiredPrayerList =
        await SQLHelper.getPrayerListByDate(widget.cardDate);

    if (requiredPrayerList != null && requiredPrayerList.isNotEmpty) {
      List<dynamic> prayerDataList = jsonDecode(requiredPrayerList);
      // Loop through the weather data list in steps of 4 to process each weather entry
      for (int i = 0; i < prayerDataList.length; i += 2) {
        String prayerTime = prayerDataList[i];
        String prayerName = prayerDataList[i + 1];

        print("Prayer Time = $prayerTime");
        print("Prayer Name = $prayerName");
        print("================================");

        // Add user location data to rowData list
        addNewMessageData(
          FontAwesomeIcons.mosque, // Weather icon based on condition
          prayerTime, // Time
          prayerName, // address
          "body", // Body
          'prayer',
          () {},
        );

        String text = 'You have offered "$prayerName Prayer" at "$prayerTime".';
        addNewString(
          prayerTime, // Time
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

        List<dynamic> sendDataList = [];
        sendDataList.add(callLocationLat);
        sendDataList.add(callLocationLong);
        sendDataList.add(callName);

        String? sendDataString = jsonEncode(sendDataList);
        // Add user location data to rowData list
        addNewMessageData(
          FontAwesomeIcons.phone, // Weather icon based on condition
          callTime, // Time
          sendDataString, // lat, long, name == address
          callNumber, // number == body
          'callLocation',
          () {},
        );

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

  @override
  void initState() {
    fetchInboxMessages();
    fetchWeatherData();
    fetchMobileUsageTime();
    fetchUserLocationData();
    fetchCallLocationData();
    fetchPrayerData();
    super.initState();
  }

  ///
  bool isSubtitleVisible = false;
  bool isThoughtsVisible = false;
  TextEditingController subtitleController = TextEditingController();
  TextEditingController thoughtsController = TextEditingController();

  ///

  @override
  Widget build(BuildContext context) {
    // Sort the rowData list before displaying
    sortRowDataByTime();

    // Concatenate rowDataText strings
    String rowDataTextText =
        rowDataText.map((data) => "${data['text']}").join(' ');

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.pen,
              color: Colors.blue,
            ),
            onPressed: () {
              Get.to(
                () => CardEditScreen(
                  cardIcon: widget.cardIcon,
                  cardDate: widget.cardDate,
                  cardID: widget.cardID,
                  cardTitle: widget.cardTitle,
                  cardSubTitle: widget.cardSubTitle,
                  cardThought: widget.cardThought,
                  color: widget.color,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              Get.snackbar(
                "DELETE", // Title
                "Are you sure you want to delete ${widget.cardDate} data?",
                // Message
                snackPosition: SnackPosition.BOTTOM,
                // You can adjust the position as needed
                duration: const Duration(seconds: 3),
                // You can adjust the duration as needed
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                mainButton: TextButton(
                  onPressed: () async {
                    print("Card ID: ${widget.cardID} ....");
                    await SQLHelper.deleteItem(int.parse(widget.cardID));
                    Get.offAll(() => const BottomNavigationBarWidget());
                  },
                  child: Text(
                    "Confirm".toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isSubtitleVisible = !isSubtitleVisible;
                                  if (isSubtitleVisible) {
                                    subtitleController.text = widget
                                        .cardSubTitle; //'Initial subtitle value';
                                  }
                                  isThoughtsVisible = false;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: isSubtitleVisible
                                    ? WidgetStateProperty.all(Colors.green)
                                    : WidgetStateProperty.all(Colors.blue),
                              ),
                              child: isSubtitleVisible
                                  ? const Text("Hide Subtitle")
                                  : const Text("Show Subtitle"),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isThoughtsVisible = !isThoughtsVisible;
                                  if (isThoughtsVisible) {
                                    thoughtsController.text = widget
                                        .cardThought; //'Initial 3am thoughts';
                                  }
                                  isSubtitleVisible = false;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: isThoughtsVisible
                                    ? WidgetStateProperty.all(Colors.green)
                                    : WidgetStateProperty.all(Colors.blue),
                              ),
                              child: isThoughtsVisible
                                  ? const Text("Hide Thoughts")
                                  : const Text("Show Thoughts"),
                            ),
                          ),
                        ],
                      ),
                      // below if is textfield code
                      if (isSubtitleVisible || isThoughtsVisible)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextField(
                            enabled: false,
                            keyboardType: TextInputType.text,
                            maxLines: 8,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                            controller: isSubtitleVisible
                                ? subtitleController
                                : thoughtsController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: isSubtitleVisible
                                  ? 'Subtitle is empty'
                                  : '3am Thoughts is empty',
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // logo code
                  Column(
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
                Get.to(
                  () => CardTraditionalScreen(
                    cardIcon: widget.cardIcon,
                    color: widget.color,
                    cardDate: widget.cardDate,
                    cardID: widget.cardID,
                    cardTitle: widget.cardTitle,
                    cardSubTitle: widget.cardSubTitle,
                    cardThoughts: widget.cardThought,
                    cardText: rowDataTextText,
                  ),
                );
                //Get.to(() => const WeatherPage());
                /// Delete Weather Page
                /// Delete Mobile Usage Time Page
                // Get.to(() => const StepCounter());
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

  Widget _buildRow(IconData iconData, String time, String address, String body,
      String msgOrWeather, Color backgroundColor, Function onPressed) {
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
          icon: Icon(
            iconData,
            size: 30,
          ),
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
                    title: Text(
                        "City Name: $address\nTime: $time\nTemperature: $body"),
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
                } // Inside your function or method
                else if (msgOrWeather == 'userLocation') {
                  // Convert latitude and longitude strings to doubles
                  double latitude = double.parse(address);
                  double longitude = double.parse(body);

                  return FutureBuilder<List<Placemark>>(
                    future: placemarkFromCoordinates(latitude, longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String? locationName = snapshot.data?[0].name;

                        return AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                          title: Text("Time: $time\nAddress: $locationName"),
                          contentPadding: const EdgeInsets.all(20.0),
                          content: SizedBox(
                            height: 300,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(latitude, longitude),
                                zoom: 16,
                              ),
                              markers: <Marker>{
                                Marker(
                                  markerId: const MarkerId('userLocation'),
                                  position: LatLng(latitude, longitude),
                                  infoWindow: InfoWindow(
                                    title: 'Location Address',
                                    snippet: locationName,
                                  ),
                                ),
                              },
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else if (msgOrWeather == 'callLocation') {
                  List<dynamic> sendDataList = jsonDecode(address);

                  // Convert latitude and longitude strings to doubles
                  double latitude = double.parse(sendDataList[0]);
                  double longitude = double.parse(sendDataList[1]);
                  String callName = sendDataList[2];

                  return FutureBuilder<List<Placemark>>(
                    future: placemarkFromCoordinates(latitude, longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String? locationName = snapshot.data?[0].name;

                        return AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                          title: Text(
                              "Time: $time\nNumber: $body\nName: $callName\nAddress: $locationName"),
                          contentPadding: const EdgeInsets.all(20.0),
                          content: SizedBox(
                            height: 300,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(latitude, longitude),
                                zoom: 16,
                              ),
                              markers: <Marker>{
                                Marker(
                                  markerId: const MarkerId('Call Location'),
                                  position: LatLng(latitude, longitude),
                                  infoWindow: InfoWindow(
                                    title: 'Location Address',
                                    snippet: locationName,
                                  ),
                                ),
                              },
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else if (msgOrWeather == 'prayer') {
                  return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      ),
                    ],
                    title: Center(child: Text("$address Prayer\nTime: $time")),
                    contentPadding: const EdgeInsets.all(20.0),
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
