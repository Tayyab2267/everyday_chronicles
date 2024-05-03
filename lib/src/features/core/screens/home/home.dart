import 'dart:convert';

import 'package:call_log/call_log.dart';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common_widgets/cards/daily_record_card.dart';
import '../../../../constants/colors.dart';
import '../../controllers/selected_tags_controller.dart';
import '../../controllers/weather_controller.dart';
import '../card/card_screen.dart';
import 'package:carp_background_location/carp_background_location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SelectedTagsController _selectedTagsController =
      Get.put(SelectedTagsController());

  final WeatherController _weatherController = WeatherController();

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  List<dynamic> weatherList = [];

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    print("Fetched items: $data");
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  Future<void> requestPermissions() async {
    // Request the necessary permissions
    Map<Permission, PermissionStatus> permissions = await [
      Permission.manageExternalStorage,
      Permission.backgroundRefresh,
      Permission.ignoreBatteryOptimizations,
      Permission.phone,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _refreshJournals();
    print("...Number of items: ${_journals.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 2,
        title: Text(
          "Home 2",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // List<dynamic> callLocationData = [];
              // // Fetch call logs from phone
              // Iterable<CallLogEntry> callLogs = await CallLog.get();
              // // Get the current date
              // DateTime now = DateTime.now();
              // String currentDate = DateFormat('MMM dd, yyyy').format(now);
              //
              // // Filter call logs for the current date
              // Iterable<CallLogEntry> currentCallLogs = callLogs.where((call) {
              //   // Extract the date from the call timestamp
              //   DateTime callDateTime =
              //       DateTime.fromMillisecondsSinceEpoch(call.timestamp!);
              //   String callDate =
              //       DateFormat('MMM dd, yyyy').format(callDateTime);
              //
              //   // Return true if the call date matches the current date
              //   return callDate == currentDate;
              // });
              //
              // // Iterate over filtered call logs
              // for (var call in currentCallLogs) {
              //   print("===============================");
              //   print("Call Time: ${call.timestamp}");
              //   print("Call Address: ${call.number}");
              //   print("Call Name: ${call.name}");
              //   print("===============================");
              //
              //   DateTime recentCallTime =
              //       DateTime.fromMillisecondsSinceEpoch(call.timestamp!);
              //   String formattedTime =
              //       '${recentCallTime.hour.toString().padLeft(2, '0')}:${recentCallTime.minute.toString().padLeft(2, '0')}';
              //   //print("----> Recent call time: $recentCallTime");
              //   print("----> RECENT CALL TIME: $formattedTime");
              //   DateTime now = DateTime.now();
              //   String presentDate =
              //       DateFormat('MMM dd, yyyy').format(now).toString();
              //   // Fetch recent call time from the database
              //   String? requiredCallLocationList =
              //       await SQLHelper.getCallLocationListByDate(presentDate);
              //   print("-----> LIST FROM DATABASE: $requiredCallLocationList");
              //   // Check if recent call time is equal to recent call time from database
              //
              //   if (requiredCallLocationList != null) {
              //     callLocationData = jsonDecode(requiredCallLocationList);
              //
              //     bool check = false;
              //     for (int i = 0; i < callLocationData.length; i += 5) {
              //       if (callLocationData[i] == formattedTime.toString()) {
              //         print("$formattedTime == ${callLocationData[i]}");
              //         print(
              //             "-----> CALL TIME == DATABASE TIME. EXITING...");
              //         check = true; // call found
              //         break;
              //       } else {
              //         print(callLocationData[i] +
              //             " != " +
              //             formattedTime.toString());
              //         check = false;// call not found
              //       }
              //     }
              //
              //     if(check == false){
              //       // configure the location manager
              //       LocationManager().interval = 1;
              //       LocationManager().distanceFilter = 0;
              //       LocationManager().notificationTitle = 'CARP Location Example';
              //       LocationManager().notificationMsg = 'CARP is tracking your location';
              //       final location = await LocationManager().getCurrentLocation();
              //
              //       callLocationData.add(formattedTime.toString());
              //       callLocationData.add(call.number.toString());
              //       callLocationData.add(location.latitude.toString());
              //       callLocationData.add(location.longitude.toString());
              //       callLocationData.add(call.name.toString());
              //
              //       print(
              //           "-----> UPDATED CALL LOCATION LIST: $callLocationData");
              //
              //       // Update database with userLocationData
              //       SQLHelper.updateItemCallLocationByDate(
              //           presentDate, jsonEncode(callLocationData));
              //       print("-----> FUNCTION END");
              //     }
              //
              //   } else {
              //     print("DATABASE IS NULL");
              //     // configure the location manager
              //     LocationManager().interval = 1;
              //     LocationManager().distanceFilter = 0;
              //     LocationManager().notificationTitle = 'CARP Location Example';
              //     LocationManager().notificationMsg = 'CARP is tracking your location';
              //     final location = await LocationManager().getCurrentLocation();
              //     // Save data into userLocationData
              //     callLocationData.add(formattedTime.toString());
              //     callLocationData.add(call.number.toString());
              //     callLocationData.add(location.latitude.toString());
              //     callLocationData.add(location.longitude.toString());
              //     callLocationData.add(call.name.toString());
              //     print("-----> CALL LIST: $callLocationData");
              //
              //     // Update database with userLocationData
              //     SQLHelper.updateItemCallLocationByDate(
              //         presentDate, jsonEncode(callLocationData));
              //     print("-----> FUNCTION END");
              //   }
              // }
              //
              //
              // LocationManager().stop();
              // print("=========== SERVICE STOPS =========");
            },
            icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
          ),
          IconButton(
            onPressed: () async {
              LocationManager().stop();
              print("=========== SERVICE STOPS =========");

              Get.offAll(() => const BottomNavigationBarWidget());
              //FilterScreen.buildShowModalBottomSheet(context);
            },
            icon: const Icon(FontAwesomeIcons.rotate, size: 16),
          ),
        ],
        backgroundColor: myBackgroundLightColor,
        leading: IconButton(
          onPressed: () {
            Get.to(
              () => const ProfileScreen(),
              transition: Transition.leftToRight,
              duration: const Duration(milliseconds: 400),
            );
          },
          icon: const Icon(Icons.person, size: 20),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: SQLHelper.getItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while fetching data
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if fetching data fails
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              // Extract data from snapshot
              final journals = snapshot.data ?? [];

              return ListView.builder(
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final record = journals[index].cast<String,
                      dynamic>(); // Create a mutable copy of the record

                  return DailyRecordCard(
                    onTap: () {
                      // Navigate to card screen
                      Get.to(
                        () => CardScreen(
                          // Pass data to card screen
                          cardIcon: record['icon'] == "fantastic"
                              ? FontAwesomeIcons.faceLaughBeam
                              : record['icon'] == "happy"
                                  ? FontAwesomeIcons.faceSmile
                                  : record['icon'] == "fine"
                                      ? FontAwesomeIcons.faceMeh
                                      : record['icon'] == "sad"
                                          ? FontAwesomeIcons.faceSadTear
                                          : record['icon'] == "worst"
                                              ? FontAwesomeIcons.faceAngry
                                              : FontAwesomeIcons.faceLaughBeam,
                          // Set your color here
                          cardDate: record['date'],
                          cardTitle: record['title'],
                          cardSubTitle: record['subtitle'],
                          cardID: record['id'].toString(),
                          color: record['icon'] == "fantastic"
                              ? Colors.green
                              : record['icon'] == "happy"
                                  ? Colors.blue
                                  : record['icon'] == "fine"
                                      ? Colors.blueGrey
                                      : record['icon'] == "sad"
                                          ? Colors.yellow
                                          : record['icon'] == "worst"
                                              ? Colors.orange
                                              : Colors.green,
                        ),
                      );
                    },
                    cardIcon: record['icon'] == "fantastic"
                        ? FontAwesomeIcons.faceLaughBeam
                        : record['icon'] == "happy"
                            ? FontAwesomeIcons.faceSmile
                            : record['icon'] == "fine"
                                ? FontAwesomeIcons.faceMeh
                                : record['icon'] == "sad"
                                    ? FontAwesomeIcons.faceSadTear
                                    : record['icon'] == "worst"
                                        ? FontAwesomeIcons.faceAngry
                                        : FontAwesomeIcons.faceLaughBeam,
                    cardDate: record['date'],
                    cardTitle: record['title'],
                    cardSubTitle: record['subtitle'],
                    color: record['icon'] == "fantastic"
                        ? Colors.green
                        : record['icon'] == "happy"
                            ? Colors.blue
                            : record['icon'] == "fine"
                                ? Colors.blueGrey
                                : record['icon'] == "sad"
                                    ? Colors.yellow
                                    : record['icon'] == "worst"
                                        ? Colors.orange
                                        : Colors.green, // Set your color here
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
