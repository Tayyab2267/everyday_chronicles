import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';

class CardTraditionalScreen extends StatefulWidget {
  const CardTraditionalScreen({
    super.key,
    required this.cardIcon,
    required this.cardDate,
    required this.cardID,
    required this.cardTitle,
    required this.cardSubTitle,
    required this.cardThoughts,
    required this.cardText,
    required this.color,
  });

  final IconData cardIcon;
  final Color color;
  final String cardID,
      cardDate,
      cardTitle,
      cardSubTitle,
      cardThoughts,
      cardText;

  @override
  State<CardTraditionalScreen> createState() => _CardTraditionalScreenState();
}

class _CardTraditionalScreenState extends State<CardTraditionalScreen> {
  ///
  bool isSubtitleVisible = false;
  bool isThoughtsVisible = false;
  TextEditingController subtitleController = TextEditingController();
  TextEditingController thoughtsController = TextEditingController();

  ///

  @override
  Widget build(BuildContext context) {
    String rowDataTextText = widget.cardText;

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
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 80, left: 20, right: 20),
          child: Column(
            children: [
              //subtitle and 3am thoughts code
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
                                    .cardThoughts; //'Initial 3am thoughts';
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
              // text
              Text(
                rowDataTextText,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 18.0),
              ),
            ],
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
                Get.back();
              },
              backgroundColor: color1,
              tooltip: "Close Traditional Page",
              child: const FaIcon(FontAwesomeIcons.book, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
