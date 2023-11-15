import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/on_boarding/on_boarding_screen.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 2500));

    // Check if onboarding has been completed
    bool onboardingCompleted = await _checkOnboardingStatus();

    // Navigate accordingly
    if (onboardingCompleted) {
      Get.off(() => const WelcomeScreen());
    } else {
      Get.off(() => const OnBoardingScreen());
    }
  }

  Future<bool> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if the "onboarding_completed" flag is set to true
    bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    return onboardingCompleted;
  }

  Future<void> setOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Set the "onboarding_completed" flag to true
    prefs.setBool('onboarding_completed', true);
  }

}
