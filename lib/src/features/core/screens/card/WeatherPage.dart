import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../model/weather_model.dart';
import '../../controllers/weather_controller.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherController _weatherController = WeatherController();
  List<dynamic> _weatherData = [];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  _fetchWeatherData() async {
    final weatherData = await _weatherController.fetchWeatherData();
    setState(() {
      _weatherData = weatherData;
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weatherData.isNotEmpty ? _weatherData[0] ?? "Loading city.." : "Loading city.."),
            Icon(
              getWeatherCondition(_weatherData.isNotEmpty ? _weatherData[1] : null),
              size: 100,
            ),
            Text('${_weatherData.isNotEmpty ? _weatherData[2] : ""} C'),
            Text(_weatherData.isNotEmpty ? _weatherData[1] ?? "" : ""),
          ],
        ),
      ),
    );
  }
}
