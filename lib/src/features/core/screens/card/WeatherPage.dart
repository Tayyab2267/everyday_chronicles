// import 'package:flutter/material.dart';
// import '../../controllers/location_service.dart';
//
// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key});
//
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   String _currentLocation = 'Fetching Location...';
//
//   @override
//   void initState() {
//     super.initState();
//     _initLocationService();
//   }
//
//   void _initLocationService() async {
//     String? cityName = await LocationService.getCurrentCity();
//     setState(() {
//       _currentLocation = cityName!;
//     });
//     // LocationService.getCurrentCity((String city) {
//     //   setState(() {
//     //     _currentLocation = city;
//     //   });
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Location Example'),
//       ),
//       body: Center(
//         child: Text(_currentLocation),
//       ),
//     );
//   }
// }
