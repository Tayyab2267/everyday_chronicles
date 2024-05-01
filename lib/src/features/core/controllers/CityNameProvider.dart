import 'package:flutter/cupertino.dart';

class CityNameProvider extends ChangeNotifier {
  String? _cityName;

  String? get cityName => _cityName;

  set cityName(String? value) {
    _cityName = value;
    notifyListeners();
  }
}