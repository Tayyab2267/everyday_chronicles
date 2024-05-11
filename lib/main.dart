import 'dart:async';
import 'dart:convert';
import 'package:call_log/call_log.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:everyday_chronicles/src/features/core/controllers/background_service_controller.dart';
import 'package:everyday_chronicles/src/features/core/controllers/noti.dart';
import 'package:everyday_chronicles/src/features/core/controllers/sql_helper.dart';
import 'package:everyday_chronicles/src/features/core/controllers/weather_service.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:everyday_chronicles/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
      case 'create_dummy_data_service':
        {
          print(" ------> Create Service");
          await _backgroundService.taskOneCreateDummyDayDataService();
        }
        break;
      case 'mood_service':
        {
          print(" ------> Mood Service");
          await _backgroundService.moodServiceMethod();
        }
        break;
      case 'fajar_prayer_service':
        {
          print(" ------> Fajar Prayer Service");
          await _backgroundService.fajarPrayerMethod();
        }
        break;
      case 'zuhar_prayer_service':
        {
          print(" ------> zuhar Prayer Service");
          await _backgroundService.zuharPrayerMethod();
        }
        break;
      case 'asar_prayer_service':
        {
          print(" ------> Asar Prayer Service");
          await _backgroundService.asarPrayerMethod();
        }
        break;
      case 'maghrib_prayer_service':
        {
          print(" ------> Maghrib Prayer Service");
          await _backgroundService.maghribPrayerMethod();
        }
        break;
      case 'isha_prayer_service':
        {
          print(" ------> Isha Prayer Service");
          await _backgroundService.ishaPrayerMethod();
        }
        break;
      case 'weather_service':
        {
          print(" ------> Weather Service");
          final WeatherService weatherService =
              WeatherService('d5e0785bbb2b18fc6cd370794e1ab333');

          List<dynamic> weatherData = [];

          String? cityName = '';
          try {
            // get the current location
            // LocationManager locationManagerWeather = LocationManager();
            // locationManagerWeather.interval = 1;
            // locationManagerWeather.distanceFilter = 0;
            // locationManagerWeather.notificationTitle = 'Weather Location';
            // locationManagerWeather.notificationMsg = 'CARP is tracking your location for weather';
            // configure the location manager
            LocationManager().interval = 1;
            LocationManager().distanceFilter = 0;
            LocationManager().notificationTitle = 'CARP Location Example';
            LocationManager().notificationMsg =
                'CARP is tracking your location';
            final location = await LocationManager().getCurrentLocation();
            List<Placemark> placemarks = await placemarkFromCoordinates(
              location.latitude,
              location.longitude,
            );
            print("----> Location Home: ${placemarks[0].locality.toString()}");

            cityName = placemarks[0].locality.toString();
            //cityName = await LocationService.getCurrentCity();
            print("---> Position: ${cityName.toString()} ...");

            // LocationManager().stop();
            // print("Weather Location Manager has been stopped......");
          } catch (ex) {
            print("--> Exception Occur: ${ex.toString()}");
          }

          if (cityName != null) {
            final weather = await weatherService
                .getWeather(cityName!); // Await the weather fetching
            print("-----> Weather: $weather");

            DateTime now = DateTime.now();
            String formattedTime =
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

            weatherData.add(formattedTime);
            weatherData.add(cityName);
            weatherData.add(weather.mainCondition);
            weatherData.add(weather.temp.round());

            print("-----> Weather Data Main Class: $weatherData");

            String presentDate =
                DateFormat('MMM dd, yyyy').format(now).toString();
            String? requiredWeatherList =
                await SQLHelper.getWeatherListByDate(presentDate);
            print("-----> weatherList from Database: $requiredWeatherList");

            if (requiredWeatherList != null) {
              // Unpack the requiredWeatherList and add its elements to weatherData
              List<dynamic> unpackedWeatherList =
                  jsonDecode(requiredWeatherList);
              weatherData.addAll(unpackedWeatherList);
              print(
                  "-----> add database weather list to weatherdata: $weatherData");
            } else {
              print(
                  "-----> No weather list found in the database or it's empty.");
            }

            SQLHelper.updateItemWeatherByDate(
                presentDate, jsonEncode(weatherData));
            print("-----> End Function");
          } else {
            print("-----> City name not available.");
          }
        }
        break;
      case 'user_location_service':
        {
          print(" ------> Location Service");
          List<dynamic> userLocationData = [];

          // // configure the location manager
          // LocationManager locationManagerUser = LocationManager();
          // locationManagerUser.interval = 1;
          // locationManagerUser.distanceFilter = 0;
          // locationManagerUser.notificationTitle = 'User Location';
          // locationManagerUser.notificationMsg = 'CARP is tracking your location';
          // configure the location manager
          LocationManager().interval = 1;
          LocationManager().distanceFilter = 0;
          LocationManager().notificationTitle = 'CARP Location Example';
          LocationManager().notificationMsg = 'CARP is tracking your location';
          final location = await LocationManager().getCurrentLocation();
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          print("----> Latitude: ${location.latitude} ...");
          print("----> Longitude: ${location.longitude} ...");
          print("----> House Address: ${placemarks[0].name.toString()}");
          // LocationManager().stop();
          // print("---> User Location Manager Stops .........");

          DateTime now = DateTime.now();
          String formattedTime =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

          userLocationData.add(formattedTime);
          userLocationData.add(location.latitude.toString());
          userLocationData.add(location.longitude.toString());

          print("-----> User Location Data Main Class: $userLocationData");

          String presentDate =
              DateFormat('MMM dd, yyyy').format(now).toString();
          String? requiredUserLocationList =
              await SQLHelper.getUserLocationListByDate(presentDate);
          print(
              "-----> userLocationList from Database: $requiredUserLocationList");

          if (requiredUserLocationList != null) {
            // Unpack the requiredUserLocationList and compare locations
            List<dynamic> unpackedUserLocationList =
                jsonDecode(requiredUserLocationList);
            double prevLat = double.parse(unpackedUserLocationList[1]);
            double prevLong = double.parse(unpackedUserLocationList[2]);
            print("------> prevLat = $prevLat");
            print("-----> prevLong = $prevLong");

            double distanceInMeters = Geolocator.distanceBetween(
                prevLat, prevLong, location.latitude, location.longitude);
            print("-----> Distance in meters$distanceInMeters");
            // Define a radius (in meters) within which a location change is considered insignificant
            double radius = 300; // Adjust this value as needed

            if (distanceInMeters > radius) {
              // Location has changed significantly, add the new location data
              userLocationData.addAll(unpackedUserLocationList);
              print(
                  "-----> Adding database user Location list to userLocationData: $userLocationData");
            } else {
              print(
                  "-----> Location change within radius, skipping adding location data.");
              break; // Skip adding location data if within radius
            }
          } else {
            print(
                "-----> No user location list found in the database or it's empty. Adding new location data.");
          }

          SQLHelper.updateItemUserLocationByDate(
              presentDate, jsonEncode(userLocationData));
          print("-----> End Function");
        }
        break;
      case 'call_location_service':
        {
          print(" ------> Call Service");
          List<dynamic> callLocationData = [];
          // Fetch call logs from phone
          Iterable<CallLogEntry> callLogs = await CallLog.get();
          // Get the current date
          DateTime now = DateTime.now();
          String currentDate = DateFormat('MMM dd, yyyy').format(now);

          // Filter call logs for the current date
          Iterable<CallLogEntry> currentCallLogs = callLogs.where((call) {
            // Extract the date from the call timestamp
            DateTime callDateTime =
                DateTime.fromMillisecondsSinceEpoch(call.timestamp!);
            String callDate = DateFormat('MMM dd, yyyy').format(callDateTime);

            // Return true if the call date matches the current date
            return callDate == currentDate;
          });

          // // configure the location manager
          // LocationManager locationManagerCall = LocationManager();
          // locationManagerCall.interval = 1;
          // locationManagerCall.distanceFilter = 0;
          // locationManagerCall.notificationTitle = 'Call Location';
          // locationManagerCall.notificationMsg = 'CARP is tracking your call location';

          // configure the location manager
          LocationManager().interval = 1;
          LocationManager().distanceFilter = 0;
          LocationManager().notificationTitle = 'CARP Location Example';
          LocationManager().notificationMsg =
          'CARP is tracking your location';
          final location = await LocationManager().getCurrentLocation();

          // Iterate over filtered call logs
          for (var call in currentCallLogs) {
            print("===============================");
            print("Call Time: ${call.timestamp}");
            print("Call Address: ${call.number}");
            print("Call Name: ${call.name}");
            print("===============================");

            DateTime recentCallTime =
                DateTime.fromMillisecondsSinceEpoch(call.timestamp!);
            String formattedTime =
                '${recentCallTime.hour.toString().padLeft(2, '0')}:${recentCallTime.minute.toString().padLeft(2, '0')}';
            //print("----> Recent call time: $recentCallTime");
            print("----> RECENT CALL TIME: $formattedTime");
            DateTime now = DateTime.now();
            String presentDate =
                DateFormat('MMM dd, yyyy').format(now).toString();
            // Fetch recent call time from the database
            String? requiredCallLocationList =
                await SQLHelper.getCallLocationListByDate(presentDate);
            print("-----> LIST FROM DATABASE: $requiredCallLocationList");
            // Check if recent call time is equal to recent call time from database

            if (requiredCallLocationList != null) {
              callLocationData = jsonDecode(requiredCallLocationList);

              bool check = false;
              for (int i = 0; i < callLocationData.length; i += 5) {
                if (callLocationData[i] == formattedTime.toString()) {
                  print("$formattedTime == ${callLocationData[i]}");
                  print("-----> CALL TIME == DATABASE TIME. EXITING...");
                  check = true; // call found
                  break;
                } else {
                  print(
                      callLocationData[i] + " != " + formattedTime.toString());
                  check = false; // call not found
                }
              }

              if (check == false) {
                // // configure the location manager
                // LocationManager().interval = 1;
                // LocationManager().distanceFilter = 0;
                // LocationManager().notificationTitle = 'CARP Location Example';
                // LocationManager().notificationMsg =
                //     'CARP is tracking your location';
                // final location = await LocationManager().getCurrentLocation();

                callLocationData.add(formattedTime.toString());
                callLocationData.add(call.number.toString());
                callLocationData.add(location.latitude.toString());
                callLocationData.add(location.longitude.toString());
                callLocationData.add(call.name.toString());

                print("-----> UPDATED CALL LOCATION LIST: $callLocationData");

                // Update database with userLocationData
                SQLHelper.updateItemCallLocationByDate(
                    presentDate, jsonEncode(callLocationData));
                print("-----> FUNCTION END");
              }
            } else {
              print("DATABASE IS NULL");
              // // configure the location manager
              // LocationManager().interval = 1;
              // LocationManager().distanceFilter = 0;
              // LocationManager().notificationTitle = 'CARP Location Example';
              // LocationManager().notificationMsg =
              //     'CARP is tracking your location';
              // final location = await LocationManager().getCurrentLocation();
              // Save data into userLocationData
              callLocationData.add(formattedTime.toString());
              callLocationData.add(call.number.toString());
              callLocationData.add(location.latitude.toString());
              callLocationData.add(location.longitude.toString());
              callLocationData.add(call.name.toString());
              print("-----> CALL LIST: $callLocationData");

              // Update database with userLocationData
              SQLHelper.updateItemCallLocationByDate(
                  presentDate, jsonEncode(callLocationData));
              print("-----> FUNCTION END");
            }
          }

          // LocationManager().stop();
          // print(" Call Location Manager STOPS .......");
        }
        break;

      default:
    }
    return Future.value(true);
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and AuthenticationRepository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthenticationRepository());

  // Initialize Work manager (background services package)
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Noti.initialize(flutterLocalNotificationsPlugin);

  /// awesome_notification
  await Noti.initializeNotification();

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
