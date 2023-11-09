import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/theme/widget_themes/text_theme.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();

    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: myBackgroundLightColor,
      body: Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: splashController.animate.value ? 300 : 200,
              left: mediaQuery.size.width * 0.1,
              right: mediaQuery.size.width * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appTagLine, style: MyTextTheme.lightTextTheme.headline3, textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 120 : 80,
              left: 50,
              child: const Image(image: AssetImage(splashImage)),
            ),
          ),
        ],
      ),
    );
  }
}
