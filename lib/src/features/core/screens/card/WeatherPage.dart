import 'package:everyday_chronicles/src/features/core/controllers/weather_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../model/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('d5e0785bbb2b18fc6cd370794e1ab333');
  Weather? _weather;

  _fetchWeather() async {
    String? cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName!);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  IconData? getWeatherCondition(String? mainCondition) {
    if (mainCondition == null) return FontAwesomeIcons.solidSun;

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return FontAwesomeIcons.cloud;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return FontAwesomeIcons.cloudRain;
      case 'thunderstorm':
        return FontAwesomeIcons.cloudBolt;
      case 'clear':
        return FontAwesomeIcons.solidSun;
      default:
        return FontAwesomeIcons.solidSun;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading city.."),
            // Load a Lottie file from a remote url
            Icon(
              getWeatherCondition(_weather?.mainCondition),
              // Call the function directly inside Icon
              size: 100,
            ),
            Text('${_weather?.temp.round()} C'),
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
