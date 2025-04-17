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
    var widthScreen = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Calendar",
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
              DailyRecordCard(
                color: Colors.green,
                cardIcon: LineAwesomeIcons.smile, // Replaced with a valid icon
                cardTitle: "Walking and Eating",
                cardSubTitle:
                    "Just the dummy text nothing else. Don't take this text seriously, it's just for practice.",
                cardSummary:
                    "Just the dummy text nothing else. Don't take this text seriously, it's just for practice.",
                cardDate: "Nov 20,\n2023",
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard(Icons.call, "15 Calls", widthScreen),
                  _buildInfoCard(
                      Icons.directions_walk, "4 km Walk", widthScreen),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard(Icons.bed, "8 Hrs Sleep", widthScreen),
                  _buildInfoCard(Icons.location_on, "Location", widthScreen),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard(Icons.photo, "10 Images", widthScreen),
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
    // Use a logger instead of print in production code (use logger package)
    // logger.d(formattedDate);
    print(formattedDate); // Temporarily keeping for now.
  }

  Widget _buildInfoCard(IconData icon, String text, double widthScreen) {
    return Container(
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
            icon,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 40,
          ),
          const SizedBox(height: 10),
          Divider(
            color: Get.isDarkMode ? Colors.white38 : Colors.grey.shade300,
            thickness: 2,
            height: 20.0,
          ),
          Text(text),
        ],
      ),
    );
  }
}
