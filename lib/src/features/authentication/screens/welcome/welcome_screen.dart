import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:everyday_chronicles/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:everyday_chronicles/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../../../../constants/text_strings.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? myBackgroundDarkColor : myBackgroundLightColor,
      body: Container(
        padding: const EdgeInsets.all(myDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: const AssetImage(myWelcomeImage1),
              height: height * 0.5,
            ),
            Column(
              children: [
                Text(
                  myWelcomeTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  myWelcomeSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(
                      myLogin.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const SignupScreen());
                    },
                    child: Text(
                      mySignup.toUpperCase(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
