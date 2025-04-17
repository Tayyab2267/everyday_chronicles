import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      print("---> Weather response: ${Weather.fromJson(jsonDecode(response.body))}");
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data.');
    }
  }


  Future<String?> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    print("-----> Before getCurrentPosition()");
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("-----> After getCurrentPosition(), Position: $position");

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print("-----> Placemarks: $placemarks");

    String? city = placemarks[0].locality;
    print("-----> City: $city");

    return city;
  }
}
