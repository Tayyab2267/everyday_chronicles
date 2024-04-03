import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundServiceController extends GetxController {
  static BackgroundServiceController get instance => Get.find();

  Future<void> taskOneCreateDummyDayDataService(String email) async {

    //create dummy list for Hive Day Data
    List<dynamic> dummyList = [
      Icons.sentiment_satisfied,
      "Title Of Day",
      "Subtitle which is dummy text of the day. it will change later when a user will complete its day."
    ];

    /// Add sqflite code here
    /// /////////////////////////////
    /// ///////////////////////////
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day} ${now.month} ${now.year} ${now.hour}:${now.minute}';
    return formattedDate;
  }
}
