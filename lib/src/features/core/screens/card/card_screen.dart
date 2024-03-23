import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
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

  void addNewData(IconData iconData, String time, Function onPressed) {
    setState(() {
      rowData.add({'icon': iconData, 'time': time, 'onPressed': onPressed});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildRow(data['icon'], data['time'], timeBackgroundColor,
                        data['onPressed']),
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
                // Example usage when receiving a new message
                addNewData(Icons.message, '09:00', () {
                  //button clicked functionality here.
                  print('Message Clicked');
                });

                // Example usage when receiving a new call
                addNewData(Icons.call, '08:00', () {
                  //button clicked functionality here.
                  print('Phone Clicked');
                });
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

  Widget _buildRow(IconData iconData, String time, Color backgroundColor,
      Function onPressed) {
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
            onPressed(); // Call the provided onPressed function
          },
          iconSize: 30,
        ),
      ],
    );
  }
}
