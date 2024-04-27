import 'dart:convert';

import 'package:everyday_chronicles/src/features/core/controllers/background_service_controller.dart';
import 'package:everyday_chronicles/src/features/core/controllers/location_service.dart';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/features/core/controllers/weather_service.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:everyday_chronicles/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';

final _backgroundService = Get.put(BackgroundServiceController());

void callbackDispatcher() {
  print(" ------> callbackDispatcher() function has been run");
  Workmanager().executeTask((taskName, inputData) async {
    print(" ------> Before Switch statement");
    switch (taskName) {
      case 'task_one_create_dummy_data_service':
        {
          await  _backgroundService.taskOneCreateDummyDayDataService();
        }
        break;
      case 'task_two_fetch_weather_condition_service':
        {
          final WeatherService weatherService = WeatherService('d5e0785bbb2b18fc6cd370794e1ab333');

          List<dynamic> weatherData = [];

          String? cityName = await LocationService.getCurrentCity();
          print("---> Position: ${cityName.toString()} ...");

          final weather = await weatherService.getWeather(cityName!); // Await the weather fetching
          print("-----> Weather: $weather");

          DateTime now = DateTime.now();
          String formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

          weatherData.add(formattedTime);
          weatherData.add(cityName);
          weatherData.add(weather.mainCondition);
          weatherData.add(weather.temp.round());

          print("-----> Weather Data Main Class: $weatherData");

          String presentDate = DateFormat('MMM dd, yyyy').format(now).toString();
          String? requiredWeatherList = await SQLHelper.getWeatherListByDate(presentDate);
          print("-----> weatherList from Database: $requiredWeatherList");

          if (requiredWeatherList != null) {
            // Unpack the requiredWeatherList and add its elements to weatherData
            List<dynamic> unpackedWeatherList = jsonDecode(requiredWeatherList);
            weatherData.addAll(unpackedWeatherList);
            print("-----> add database weather list to weatherdata: $weatherData");
          } else {
            print("-----> No weather list found in the database or it's empty.");
          }

          SQLHelper.updateItemWeatherByDate(presentDate, jsonEncode(weatherData));
          print("-----> End Function");
          //_backgroundService.taskTwoFetchWeatherConditionService();
        }
        break;
      default:
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and AuthenticationRepository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());

  // Initialize Work manager (background services package)
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
      debugShowCheckedModeBanner: false,
      //home: SplashScreen(),
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
