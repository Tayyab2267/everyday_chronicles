// import 'package:flutter/foundation.dart';
// import 'package:everyday_chronicles/src/features/core/controllers/weather_service.dart';
// import 'location_service.dart';
//
// class WeatherController {
//   final WeatherService _weatherService = WeatherService('d5e0785bbb2b18fc6cd370794e1ab333');
//
//   Future<List<dynamic>> fetchWeatherData() async {
//     List<dynamic> weatherData = [];
//
//     try {
//       print("-----> Inside fetchWeatherData()");
//       String? cityName = await LocationService.getCurrentCity();
//       print("-----> cityName Location Service: $cityName");
//
//       final weather = await _weatherService.getWeather(cityName!); // Await the weather fetching
//       print("-----> Weather: $weather");
//
//       DateTime now = DateTime.now();
//       String formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
//
//       weatherData.add(formattedTime);
//       weatherData.add(cityName);
//       weatherData.add(weather.mainCondition);
//       weatherData.add(weather.temp.round());
//
//       print("-----> Weather Data: $weatherData");
//
//       return weatherData;
//     } catch (e) {
//       print("-----> Exception in fetchWeatherData(): $e");
//       if (kDebugMode) {
//         print(e);
//       }
//       return weatherData; // Return empty list if fetching fails
//     }
//   }
//
// }
