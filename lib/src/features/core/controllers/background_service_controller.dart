import 'dart:async';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BackgroundServiceController extends GetxController {
  static BackgroundServiceController get instance => Get.find();

  Future<void> taskOneCreateDummyDayDataService() async {
    print("-----> Adding new data to localDatabase");
    try {
      print("-----> Before SQL Flite ");
      await SQLHelper.createItem(getCurrentDate(), "fantastic",
          "Title of the day", "This is the dummy text");
      print("-----> After SQL Flite");
    } catch (ex) {
      print("----> Ex: ${ex.toString()}");
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();
    return presentDate.toString();
  }
}
