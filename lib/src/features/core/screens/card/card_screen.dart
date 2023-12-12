import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import 'circle_painter_end.dart';
import 'card_traditional_screen.dart';
import 'circle_painter_start.dart';

class CardScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {

    final Color timeBackgroundColor;
    timeBackgroundColor = Get.isDarkMode? color3 : Colors.grey;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        title: Text(cardDate),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(cardIcon, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                //color: Colors.greenAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("07:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const Image(image: AssetImage(clockIcon), width: 35),
                      const Image(image: AssetImage(phoneIcon), width: 35),
                      const Image(image: AssetImage(weatherIcon), width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage(cameraIcon), width: 35),
                      const Image(image: AssetImage(phoneIcon), width: 35),
                      const Image(image: AssetImage(runningIcon), width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("07:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("10:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const Image(image: AssetImage(locationIcon), width: 35),
                      const Image(image: AssetImage(phoneIcon), width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage(runningIcon), width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("11:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("12:30", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const Image(image: AssetImage(cameraIcon), width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage(weatherIcon), width: 35),
                      const Image(image: AssetImage(phoneIcon), width: 35),
                      const Image(image: AssetImage(mosqueIcon), width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("02:25", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("03:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const Image(image: AssetImage(locationIcon), width: 35),
                      const Image(image: AssetImage(cameraIcon), width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(image: AssetImage(mosqueIcon), width: 35),
                      const Image(image: AssetImage(phoneIcon), width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("09:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 35),
                      const SizedBox(width: 35),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        height: 70,
                        width: 70,
                        color: timeBackgroundColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const VerticalDivider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                            Container(
                              color: timeBackgroundColor,
                              child: Text("11:00", style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const Image(image: AssetImage(sleepIcon), width: 35),
                      const Image(image: AssetImage(weatherIcon), width: 35),
                    ],
                  ),
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
                Get.to( () => const CardTraditionalScreen());
              },
              backgroundColor: color1,
              tooltip: "Opens Traditional Page",
              child: const FaIcon(FontAwesomeIcons.bookOpen, color: Colors.white),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              if (kDebugMode) {
                print('Floating button pressed!');
              }
            },
            backgroundColor: color1,
            tooltip: "Opens Add page",
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
