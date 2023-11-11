import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:get/get.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();

    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      //backgroundColor: myWhiteColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              bottom: splashController.animate.value ? 300 : 200,
              left: mediaQuery.size.width * 0.1,
              right: mediaQuery.size.width * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    appTagLine.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 120 : 80,
              left: 50,
              child: isDarkMode
                  ? const Image(image: AssetImage(splashImageDark))
                  : const Image(
                      image: AssetImage(splashImage),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
