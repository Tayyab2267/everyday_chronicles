import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class MyOutlinedButtonTheme {
  MyOutlinedButtonTheme._();

  // Light Theme
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: mySecondaryColor,
      side: const BorderSide(color: mySecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: myButtonHeight),
    ),
  );

  // Dark Theme
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: myWhiteColor,
      side: const BorderSide(color: myWhiteColor),
      padding: const EdgeInsets.symmetric(vertical: myButtonHeight),
    ),
  );

}