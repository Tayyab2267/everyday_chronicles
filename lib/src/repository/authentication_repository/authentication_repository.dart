import 'package:carp_background_location/carp_background_location.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    setInitialScreen(firebaseUser.value);
    //ever(firebaseUser, _setInitialScreen);
  }

  Future<String> _authenticate() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      bool authenticated = await auth.authenticate(
        localizedReason: "Subscribe or you will never find any stack overflow error",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      print("Authenticated: $authenticated");
      return authenticated.toString();
    } on PlatformException catch (e) {
      print(e);
    }
    return "false";
  }

  setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      if (user.emailVerified) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool passcodeEnabled = prefs.getBool('passcodeEnabled') ?? false;
        if(passcodeEnabled == true){
          String result = await _authenticate();
          print("Result: $result");
          if(result == "true"){
            Get.offAll(() => const BottomNavigationBarWidget());
          } else {
            Get.offAll(() => const WelcomeScreen());
          }
        } else {
          Get.offAll(() => const BottomNavigationBarWidget());
        }
      } else {
        Get.offAll(() => const MailVerificationScreen());
      }
    }

    // user == null
    //     ? Get.offAll(() => const WelcomeScreen())
    //     : user.emailVerified
    //         ? Get.offAll(() => const BottomNavigationBarWidget())
    //         : Get.offAll(() => const MailVerificationScreen());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      firebaseUser.value != null
          ? Get.offAll(() => const MailVerificationScreen())
          : Get.to(() => const WelcomeScreen());

      Get.snackbar(
        "Successfully",
        "Verification email link has been sent to your email. Verify it to login.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('Firebase Auth Exception - ${ex.message}');
      Get.snackbar(
        "ERROR",
        ex.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      throw ex;
    } catch (_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('Exception -${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser.value != null) {
        if (firebaseUser.value!.emailVerified) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // bool moodServiceEnabled = prefs.getBool('mobileUsageServiceEnabled') ?? false;
          // bool weatherServiceEnabled = prefs.getBool('mobileUsageServiceEnabled') ?? false;
          // bool locationServiceEnabled = prefs.getBool('mobileUsageServiceEnabled') ?? false;
          // bool callLocationServiceEnabled = prefs.getBool('mobileUsageServiceEnabled') ?? false;
          // bool prayerServiceEnabled = prefs.getBool('mobileUsageServiceEnabled') ?? false;

          createDummyDataService();
          // moodService();
          // weatherService();
          // userLocationService();
          // callLocationService();
          // prayers services
          // fajarPrayer();
          // zuharPrayer();
          // asarPrayer();
          // maghribPrayer();
          // ishaPrayer();

          // Open home Screen
          Get.offAll(() => const BottomNavigationBarWidget());
          // Print message to screen
          Get.snackbar(
            "Successfully",
            "Log In Successfully",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.off(() => const MailVerificationScreen());
        }
      } else {
        Get.to(() => const WelcomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      Get.snackbar(
        "ERROR",
        e.code,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("FIREBASE AUTH EXCEPTION -${ex.message}");
      throw ex;
    } catch (_) {
      var ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar(
        "ERROR",
        ex.toString(),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("EXCEPTION - ${ex.message}");
      throw ex;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (_) {
      throw "Exception Occurs";
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<void> logout() async {
    //Workmanager().cancelAll();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await Workmanager().cancelByTag("create");
      print("---> create_service stopped successfully");
      await Workmanager().cancelByTag("mood");
      await prefs.setBool('moodServiceEnabled', false);
      print("---> mood_service stopped successfully");
      await Workmanager().cancelByTag("weather");
      await prefs.setBool('weatherServiceEnabled', false);
      print("---> weather_service stopped successfully");
      await Workmanager().cancelByTag("user");
      await prefs.setBool('locationServiceEnabled', false);
      print("---> user_location_service stopped successfully");
      await Workmanager().cancelByTag("call");
      await prefs.setBool('callLocationServiceEnabled', false);
      print("---> call_location_service stopped successfully");
      await Workmanager().cancelByTag("fajar");
      await prefs.setBool('prayerServiceEnabled', false);
      print("---> fajar_prayer_service stopped successfully");
      await Workmanager().cancelByTag("zuhar");
      print("---> zuhar_prayer_service stopped successfully");
      await Workmanager().cancelByTag("asar");
      print("---> asar_prayer_service stopped successfully");
      await Workmanager().cancelByTag("maghrib");
      print("---> maghrib_prayer_service stopped successfully");
      await Workmanager().cancelByTag("isha");
      print("---> isha_prayer_service stopped successfully");
    } catch (e) {
      print("---> Error stopping task: $e");
    }

    await _auth.signOut();
    LocationManager().stop();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('passcodeEnabled', false);
    Get.offAll(() => const LoginScreen());
  }

  // Function to calculate the initial delay until 12:00 AM of the next day
  // Duration _calculateInitialDelay(int seconds) {
  //   final now = DateTime.now();
  //   final nextDay = now.add(const Duration(days: 1));
  //   final midnight = DateTime(nextDay.year, nextDay.month, nextDay.day);
  //   final delay = midnight.difference(now) + Duration(seconds: seconds);
  //   return delay;
  // }

  // Duration calculateInitialDelayWithHour(int hours) {
  //   final now = DateTime.now();
  //
  //   // Add hours to the current date time
  //   final nextHour = now.add(Duration(hours: hours));
  //
  //   // If the calculated date time is in the past, add the specified hours to the next day
  //   if (nextHour.isBefore(now)) {
  //     final nextDay = now.add(const Duration(days: 1));
  //     return DateTime(nextDay.year, nextDay.month, nextDay.day, hours)
  //         .difference(now);
  //   } else {
  //     return nextHour.difference(now);
  //   }
  // }

  int calculateInitialDelayInSeconds(int hour) {
    final now = DateTime.now();

    // Create a DateTime object for the specified hour of the current day
    final todayTargetTime = DateTime(now.year, now.month, now.day, hour);

    // If the target time has already passed today, add 1 day to the date
    if (now.isAfter(todayTargetTime)) {
      final nextDay = now.add(const Duration(days: 1));
      return DateTime(nextDay.year, nextDay.month, nextDay.day, hour)
          .difference(now)
          .inSeconds;
    } else {
      // If the target time is in the future, calculate the delay in seconds
      return todayTargetTime.difference(now).inSeconds;
    }
  }

  int calculateInitialDelayForWeatherInSeconds(int hour1, int hour2, int hour3) {
    final now = DateTime.now();

    // Create DateTime objects for the specified hours of the current day
    final targetTimes = [
      DateTime(now.year, now.month, now.day, hour1),
      DateTime(now.year, now.month, now.day, hour2),
      DateTime(now.year, now.month, now.day, hour3)
    ];

    // Calculate delays for each target time
    final delays = targetTimes.map((targetTime) {
      if (now.isAfter(targetTime)) {
        final nextDay = now.add(const Duration(days: 1));
        return DateTime(nextDay.year, nextDay.month, nextDay.day, targetTime.hour)
            .difference(now)
            .inSeconds;
      } else {
        return targetTime.difference(now).inSeconds;
      }
    }).toList();

    // Find the minimum delay
    int minDelay = delays[0];
    for (int i = 1; i < delays.length; i++) {
      if (delays[i] < minDelay) {
        minDelay = delays[i];
      }
    }

    return minDelay;
  }


  Future<void> createDummyDataService() async {
    print("\t ---------> createDummyDataService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'create_dummy_data_service',
      'create_dummy_data_service',
      tag: 'create',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(0)),
      frequency: const Duration(days: 1),
    );
  }
  Future<void> moodService() async {
    print("\t ---------> moodService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'mood_service',
      'mood_service',
      tag: 'mood',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(21)),
      // initialDelay: const Duration(seconds: 10),
      frequency: const Duration(days: 1),
    );
  }
  Future<void> callLocationService() async {
    print("\t ---------> callLocationService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'call_location_service',
      'call_location_service',
      tag: 'call',
      // initialDelay: _calculateInitialDelay(20),
      initialDelay: const Duration(seconds: 60),
      frequency: const Duration(minutes: 15),
    );
  }
  Future<void> userLocationService() async {
    print("\t ---------> userLocationService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'user_location_service',
      'user_location_service',
      tag: 'user',
      // initialDelay: _calculateInitialDelay(60),
      initialDelay: const Duration(seconds: 20),
      frequency: const Duration(minutes: 15),
    );
  }
  Future<void> weatherService() async {
    print("\t ---------> weatherService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'weather_service',
      'weather_service',
      tag: 'weather',
      initialDelay: Duration(seconds: calculateInitialDelayForWeatherInSeconds(6, 14, 22)),
      frequency: const Duration(hours: 8),
    );
  }

  Future<void> fajarPrayer() async {
    print("\t ---------> Fajar Prayer Service() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'fajar_prayer_service',
      'fajar_prayer_service',
      tag: 'fajar',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(5)),
      frequency: const Duration(days: 1),
    );
  }
  Future<void> zuharPrayer() async {
    print("\t ---------> zuhar Prayer Service() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'zuhar_prayer_service',
      'zuhar_prayer_service',
      tag: 'zuhar',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(14)),
      frequency: const Duration(days: 1),
    );
  }
  Future<void> asarPrayer() async {
    print("\t ---------> asar Prayer Service() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'asar_prayer_service',
      'asar_prayer_service',
      tag: 'asar',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(17)),
      frequency: const Duration(days: 1),
    );
  }
  Future<void> maghribPrayer() async {
    print("\t ---------> maghrib Prayer Service() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'maghrib_prayer_service',
      'maghrib_prayer_service',
      tag: 'maghrib',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(19)),
      frequency: const Duration(days: 1),
    );
  }
  Future<void> ishaPrayer() async {
    print("\t ---------> isha Prayer Service() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'isha_prayer_service',
      'isha_prayer_service',
      tag: 'isha',
      initialDelay: Duration(seconds: calculateInitialDelayInSeconds(22)),
      frequency: const Duration(days: 1),
    );
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day} ${now.month} ${now.year} ${now.hour}:${now.minute}';
    return formattedDate;
  }

  String getUserEmail() {
    final email = _auth.currentUser?.email;
    // Check if email is null before calling toString()
    return email != null
        ? email.toString()
        : ""; // Return an empty string if email is null
  }
}
