import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  // Light Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      foregroundColor: myWhiteColor,
      backgroundColor: myButtonBackgroundColor,
      side: const BorderSide(color: mySecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: myButtonHeight),
      textStyle: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );

  // Dark Theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      foregroundColor: mySecondaryColor,
      backgroundColor: myWhiteColor,
      side: const BorderSide(color: mySecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: myButtonHeight),
      textStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
    ),
  );


}