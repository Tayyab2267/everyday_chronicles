import 'package:everyday_chronicles/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController{

  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 5000));
    Get.off(() => const WelcomeScreen());
    //Get.off(() => const OnBoardingScreen());
  }
}