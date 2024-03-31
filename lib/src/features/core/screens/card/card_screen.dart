import 'package:everyday_chronicles/src/features/core/screens/card/card_traditional_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import '../../../../constants/colors.dart';
import 'WeatherPage.dart';
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

  void addNewData(IconData iconData, String time, String address, String body,
      Function onPressed) {
    setState(() {
      rowData.add({
        'icon': iconData,
        'time': time,
        'address': address,
        'body': body,
        'onPressed': onPressed
      });
    });
  }

  // message code start
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> inboxMessages = [];

  Future<void> fetchInboxMessages() async {
    // Hardcoded date: March 25, 2024
    DateTime date = DateTime(2024, 3, 25);
    // Calculate the start and end of the day for the provided date
    DateTime startDate = DateTime(date.year, date.month, date.day);
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
      addNewData(
          Icons.message, // Icon for SMS message
          messageTime,
          messageAddress, // Format the date to display only time (HH:mm)
          messageBody, // Format the date to display only time (HH:mm)
          () {
        // Functionality when the message row is clicked
        if (kDebugMode) {
          print("$messageBody: MSG Icon Clicked");
        }
      });
    }
  }

  @override
  void initState() {
    fetchInboxMessages();
    super.initState();
  }
  // message code ends

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
                Get.to(() => const WeatherPage());
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
              builder: (context) => AlertDialog(
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
              ),
            );
            onPressed(); // Call the provided onPressed function
          },
          iconSize: 30,
        ),
      ],
    );
  }
}
