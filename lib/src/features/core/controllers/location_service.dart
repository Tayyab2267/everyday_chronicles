import 'dart:async';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String?> getCurrentCity() async {
    Completer<String?> completer = Completer<String?>();

    try {
      await bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
      ));

      bg.BackgroundGeolocation.onLocation((bg.Location location) async {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.coords.latitude,
            location.coords.longitude,
          );
          if (placemarks.isNotEmpty) {
            String cityName = placemarks[0].locality!;
            print("-----> CityName: $cityName .....");
            completer.complete(cityName);
            // Don't stop here, as we want to continue listening for location updates in the background
            bg.BackgroundGeolocation.stop();
          }
        } catch (e) {
          print('--> Error getting location: $e');
          completer.completeError('Location Error');
        }
      });

      bg.BackgroundGeolocation.start();
    } catch (e) {
      print('---> Error initializing background geolocation: $e');
      completer.completeError('Location Error');
    }

    return completer.future;
  }
}
