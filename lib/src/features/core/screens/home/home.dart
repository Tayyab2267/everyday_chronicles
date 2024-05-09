import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/notification_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common_widgets/cards/daily_record_card.dart';
import '../../../../constants/colors.dart';
import '../../controllers/selected_tags_controller.dart';
import '../../controllers/weather_controller.dart';
import '../card/card_screen.dart';

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
          "Home",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              Get.to(() => const NotificationScreen());
              // Get.to(() => GalleryScreen());
              // await SQLHelper.updateTable();
            },
            icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
          ),
          IconButton(
            onPressed: () async {
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
                          cardThought: record['thoughts'] ?? "",
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
