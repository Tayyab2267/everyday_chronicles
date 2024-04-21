import 'dart:convert';

import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/features/core/controllers/weather_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BackgroundServiceController extends GetxController {
  static BackgroundServiceController get instance => Get.find();

  final WeatherController _weatherController = WeatherController();

  Future<void> taskOneCreateDummyDayDataService() async {
    SQLHelper.createItem(getCurrentDate(), "fantastic", "Title of the day",
        "This is the dummy text. this text will be changed after 11:59 when your through out day will be fetched");
  }

  Future<void> taskTwoFetchWeatherConditionService() async {
    List<dynamic> weatherData = await _weatherController.fetchWeatherData();
    String weatherDataString = listToJson(weatherData);
    //String weatherDataString = listToJson(weatherData);
    SQLHelper.updateItemWeatherByDate(getCurrentDate(), weatherDataString);
  }

  /// Function to convert a list of objects to a JSON string
  String listToJson(List<dynamic> list) {
    return jsonEncode(list);
  }
  /// Function to convert a JSON string to a list of objects
  List<dynamic> jsonToList(String json) {
    return jsonDecode(json);
  }

  String getCurrentDate() {
    // Get the current date
    DateTime now = DateTime.now();
    // Format the date as "Month Date, Year"
    String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();
    return presentDate.toString();
  }
}
