import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  // Light Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: myWhiteColor,
      backgroundColor: myButtonBackgroundColor,
      side: const BorderSide(color: mySecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: myButtonHeight),
    ),
  );

  // Dark Theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: mySecondaryColor,
      backgroundColor: myWhiteColor,
      side: const BorderSide(color: mySecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: myButtonHeight),
    ),
  );


}