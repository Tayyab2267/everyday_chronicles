import 'package:everyday_chronicles/src/common_widgets/cards/daily_record_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../constants/colors.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var heightScreen = mediaQuery.size.height;
    var widthScreen = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Calender",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime(2100),
                onDateChanged: onDateChanged,
              ),
              const DailyRecordCard(
                color: Colors.green,
                cardIcon: LineAwesomeIcons.smiling_face_with_heart_eyes,
                cardTitle: "Walking and Eating",
                cardSubTitle:"Just the dummy text nothing else Don;t take this text seriously its just for practice",
                cardSummary:"Just the dummy text nothing else Don;t take this text seriously its just for practice",
                cardDate: "Nov 20,\n2023",
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: widthScreen * 0.30,
                    height: widthScreen * 0.30,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: Get.isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade300,
                          thickness: 2,
                          height: 20.0,
                        ),
                        const Text("15 Calls"),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: widthScreen * 0.30,
                    height: widthScreen * 0.30,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: Get.isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade300,
                          thickness: 2,
                          height: 20.0,
                        ),
                        const Text("4 km Walk"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: widthScreen * 0.30,
                    height: widthScreen * 0.30,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bed,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: Get.isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade300,
                          thickness: 2,
                          height: 20.0,
                        ),
                        const Text(" 8 Hrs Sleep"),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: widthScreen * 0.30,
                    height: widthScreen * 0.30,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: Get.isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade300,
                          thickness: 2,
                          height: 20.0,
                        ),
                        const Text("Location"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: widthScreen * 0.30,
                    height: widthScreen * 0.30,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          color: Get.isDarkMode
                              ? Colors.white38
                              : Colors.grey.shade300,
                          thickness: 2,
                          height: 20.0,
                        ),
                        const Text(" 10 Images"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDateChanged(DateTime value) {
    String formattedDate = "${value.year}-${value.month}-${value.day}";
    print(formattedDate);
  }
}
