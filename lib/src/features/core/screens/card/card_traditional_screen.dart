import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import 'circle_painter_end.dart';
import 'circle_painter_start.dart';

class CardTraditionalScreen extends StatelessWidget {
  const CardTraditionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        title: const Text("cardDate"),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            //color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          //child: Icon(cardIcon, color: Colors.black),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Hello World"),
      ),
    );
  }
}
