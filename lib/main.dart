import 'package:everyday_chronicles/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'src/features/authentication/screens/splash/splash_screen.dart';

void main(){
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
      home: SplashScreen(),
    );
  }
}
