import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../constants/text_strings.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<void> requestPermissions() async {
    // Request the necessary permissions
    Map<Permission, PermissionStatus> permissions = await [
      Permission.manageExternalStorage,
      Permission.backgroundRefresh,
      Permission.ignoreBatteryOptimizations,
      Permission.phone,
      Permission.storage,
      Permission.sms,
      Permission.location,
      Permission.activityRecognition,
      Permission.sensors,
    ].request();

    // Handle the result of permission requests if needed
    permissions.forEach((permission, status) {
      print('Permission ${permission.toString()} status: $status');
    });

    permissions = await [Permission.manageExternalStorage].request();
  }


  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

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
                const SizedBox(width: 10.0),
                //comment
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
