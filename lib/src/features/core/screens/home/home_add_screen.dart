import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../constants/colors.dart';
import 'bottom_navigation_bar_widget.dart';

class HomeAddScreen extends StatefulWidget {
  const HomeAddScreen({super.key});

  @override
  State<HomeAddScreen> createState() => _HomeAddScreenState();
}

class _HomeAddScreenState extends State<HomeAddScreen> {
  String selectedMood = 'fantastic'; // Variable to store the selected mood
  late String subtitle;

  @override
  void initState() {
    print("--->> check 1");
    fetchData(); // Call fetchData without awaiting
    print("--->> check 2");
    super.initState();
  }

  Future<void> fetchData() async {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();

    final data = await SQLHelper.getItemByDate(presentDate);
    print(" ---> presentDate = $presentDate");
    if (data.isNotEmpty) {
      setState(() {
        selectedMood = data[0]['icon'];
        subtitle = data[0]['subtitle'];
      });
    } else {
      setState(() {
        subtitle = '';
        return;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();
    // Format the date as "Month Date, Year"
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();

    return Scaffold(
      //backgroundColor: myHomeScreenBackgroundColor,
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor, // home screen Dark background color
      appBar: AppBar(
        foregroundColor: Colors.black,
        //elevation: 2,
        title: Text(
          presentDate,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final existingItem = await SQLHelper.getItemByDate(presentDate);
              if (existingItem.isNotEmpty) {
                await SQLHelper.updateItemByDate(
                    presentDate,
                    selectedMood.toString(),
                    subtitle.substring(0, 10),
                    subtitle.toString());
              } else {
                await SQLHelper.createItem(presentDate, selectedMood.toString(),
                    subtitle.substring(0, 10), subtitle.toString());
              }

              Get.offAll(() => const BottomNavigationBarWidget());
            },
            icon: const FaIcon(FontAwesomeIcons.check, size: 20),
          ),
        ],
        backgroundColor: myBackgroundLightColor,
        leading: IconButton(
          onPressed: () {
            print("Button Clicked");
            Get.offAll(() => const BottomNavigationBarWidget());
          },
          icon: const FaIcon(FontAwesomeIcons.xmark, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(top: 10, bottom: 50, right: 25, left: 25),
          child: Column(
            children: [
              // 1. Mood
              Material(
                elevation: 4,
                shadowColor: Get.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? myCardBackgroundDarkColor
                        : myCardBackgroundLightColor,
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the border radius as needed
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("How was your day?",
                          style: Theme.of(context).textTheme.titleLarge),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: selectedMood == 'fantastic'
                                  ? Colors.green
                                  : null,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.faceLaughBeam,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMood = 'fantastic';
                                });
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  selectedMood == 'happy' ? Colors.green : null,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.faceSmile,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMood = 'happy';
                                });
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  selectedMood == 'fine' ? Colors.green : null,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.faceMeh,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMood = 'fine';
                                });
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  selectedMood == 'sad' ? Colors.green : null,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.faceSadTear,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMood = 'sad';
                                });
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  selectedMood == 'worst' ? Colors.green : null,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.faceAngry,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMood = 'worst';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // 2. Write
              Material(
                elevation: 4,
                shadowColor: Get.isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? myCardBackgroundDarkColor
                        : myCardBackgroundLightColor,
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the border radius as needed
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Write about today",
                          style: Theme.of(context).textTheme.titleLarge),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        height: 20.0,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 12,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Get.isDarkMode
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                        initialValue: subtitle,
                        // Set the initial value to the value of subtitle
                        onChanged: (value) {
                          // Update the description variable when text changes
                          setState(() {
                            subtitle = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Type your daily doing in it...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
