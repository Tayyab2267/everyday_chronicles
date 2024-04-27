import 'dart:convert';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/features/core/controllers/weather_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BackgroundServiceController extends GetxController {
  static BackgroundServiceController get instance => Get.find();

  final WeatherController _weatherController = WeatherController();

  Future<void> taskOneCreateDummyDayDataService() async {
    print("-----> Adding new data to localDatabase");
    try{
      print("-----> Before SQL Flite ");
      await SQLHelper.createItem(getCurrentDate(), "fantastic", "Title of the day","This is the dummy text");
      print("-----> After SQL Flite");
    }catch(ex){
      print("----> Ex: ${ex.toString()}");
    }

  }

  // Future<void> taskTwoFetchWeatherConditionService() async {
  //   print("-----> Start Function");
  //
  //   List<dynamic> weatherData = [];
  //   try {
  //     print("-----> Before calling fetchWeatherData()");
  //     weatherData = await _weatherController.fetchWeatherData();
  //     print("-----> After calling fetchWeatherData()");
  //   } catch (ex) {
  //     print("-----> Exception in fetchWeatherData(): ${ex.toString()}");
  //   }
  //   print("-----> WeatherData: $weatherData");
  //   String? requiredWeatherList = await SQLHelper.getWeatherListByDate(getCurrentDate());
  //   print("-----> weatherList from Database: $requiredWeatherList");
  //
  //   if (requiredWeatherList != null) {
  //     // Unpack the requiredWeatherList and add its elements to weatherData
  //     List<dynamic> unpackedWeatherList = jsonDecode(requiredWeatherList);
  //     weatherData.addAll(unpackedWeatherList);
  //     print("-----> add database weather list to weatherdata: $weatherData");
  //   } else {
  //     print("-----> No weather list found in the database or it's empty.");
  //   }
  //
  //   SQLHelper.updateItemWeatherByDate(getCurrentDate(), jsonEncode(weatherData));
  //   print("-----> End Function");
  // }


  String getCurrentDate() {
    DateTime now = DateTime.now();
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();
    return presentDate.toString();
  }
}
