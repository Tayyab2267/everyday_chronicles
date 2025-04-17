import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:flutter/material.dart';

class MyTextFieldTheme {
  MyTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: mySecondaryColor,
    floatingLabelStyle: TextStyle(color: mySecondaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: mySecondaryColor),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: myWhiteColor,
    floatingLabelStyle: TextStyle(color: myWhiteColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: myWhiteColor),
    ),
  );
}
