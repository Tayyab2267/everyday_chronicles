import 'dart:convert';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/colors.dart';
import 'bottom_navigation_bar_widget.dart';
import 'package:http/http.dart' as http;

class HomeAddScreen extends StatefulWidget {
  const HomeAddScreen({super.key});

  @override
  State<HomeAddScreen> createState() => _HomeAddScreenState();
}

class _HomeAddScreenState extends State<HomeAddScreen> {
  String selectedMood = 'fantastic'; // Variable to store the selected mood
  String subtitle = '';
  Future<String>? _fetchDataFuture;

  String thoughts = '';
  Future<String>? _fetch3amThoughts;

  /// Text will send to server to fetch Mood
  Future<String?> sendTextToSummarize(String text) async {
    var url = 'http://192.168.0.113:5001/summarize-text';
    try{
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"text": text}));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['summary'];
      } else {
        throw Exception('Failed to send text to Flask');
      }
    } catch(e){
      print(e.toString());
    }

    return "$subtitle $thoughts";
  }

  @override
  void initState() {
    super.initState();
    fetchMood();
    _fetchDataFuture = fetchData();
    _fetch3amThoughts = fetch3amData();
  }

  Future<void> fetchMood() async {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();

    final data = await SQLHelper.getItemByDate(presentDate);
    print(" ---> presentDate = $presentDate");
    if (data.isNotEmpty) {
      setState(() {
        selectedMood = data[0]['icon'];
        subtitle = data[0]['subtitle']; // Update subtitle here
      });
    }
  }

  Future<String> fetchData() async {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();

    final data = await SQLHelper.getItemByDate(presentDate);
    print(" ---> presentDate = $presentDate");
    if (data.isNotEmpty) {
      subtitle = data[0]['subtitle'];
    }
    return subtitle;
  }

  Future<String> fetch3amData() async {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();

    final data = await SQLHelper.getItemByDate(presentDate);
    print(" ---> presentDate = $presentDate");
    if (data.isNotEmpty) {
      thoughts = data[0]['thoughts'];
    }
    return thoughts;
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
              // on check button clicked following operations will be performed

              String textToSend = "$subtitle. $thoughts";
              String? summarizeText = await sendTextToSummarize(textToSend);

              final existingItem = await SQLHelper.getItemByDate(presentDate);
              if (existingItem.isNotEmpty) {
                await SQLHelper.updateItemByDate(
                  presentDate,
                  selectedMood.toString(),
                  "true",
                  subtitle.substring(0, 10),
                  subtitle.toString(),
                  thoughts.toString(),
                  summarizeText.toString(),
                );
              } else {
                await SQLHelper.createItem(
                  presentDate,
                  selectedMood.toString(),
                  "true",
                  subtitle.substring(0, 10),
                  subtitle.toString(),
                  thoughts.toString(),
                  summarizeText.toString(),
                );
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
                              icon: FaIcon(
                                FontAwesomeIcons.faceLaughBeam,
                                color: Get.isDarkMode ? Colors.white : Colors.black,
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
                              icon: FaIcon(
                                FontAwesomeIcons.faceSmile,
                                color: Get.isDarkMode ? Colors.white : Colors.black,
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
                              icon: FaIcon(
                                FontAwesomeIcons.faceMeh,
                                color: Get.isDarkMode ? Colors.white : Colors.black,
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
                              icon: FaIcon(
                                FontAwesomeIcons.faceSadTear,
                                color: Get.isDarkMode ? Colors.white : Colors.black,
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
                              icon: FaIcon(
                                FontAwesomeIcons.faceAngry,
                                color: Get.isDarkMode ? Colors.white : Colors.black,
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
                      FutureBuilder<String>(
                        // future: fetchData(),
                        future: _fetchDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            return TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 8,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              initialValue: snapshot.data ?? '',
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
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // 2. 3am thoughts
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
                      Text("3am thoughts",
                          style: Theme.of(context).textTheme.titleLarge),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        height: 20.0,
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder<String>(
                        future: _fetch3amThoughts,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            return TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 8,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              initialValue: snapshot.data ?? '',
                              onChanged: (value) {
                                // Update the description variable when text changes
                                setState(() {
                                  thoughts = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: "Type your 3am thoughts in it...",
                                border: OutlineInputBorder(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
