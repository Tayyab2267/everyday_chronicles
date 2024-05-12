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
          // services functions
          createDummyDataService();
          moodService();
          weatherService();
          userLocationService();
          callLocationService();
          // prayers services
          fajarPrayer();
          zuharPrayer();
          asarPrayer();
          maghribPrayer();
          ishaPrayer();

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
      print("FIREBASE AUTH EXCEPTION -${ex.message}");
      throw ex;
    } catch (_) {
      var ex = SignUpWithEmailAndPasswordFailure();
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
      await Workmanager().cancelByTag("create");
      print("---> create_service stopped successfully");
      await Workmanager().cancelByTag("mood");
      print("---> mood_service stopped successfully");
      await Workmanager().cancelByTag("weather");
      print("---> weather_service stopped successfully");
      await Workmanager().cancelByTag("user");
      print("---> user_location_service stopped successfully");
      await Workmanager().cancelByTag("call");
      print("---> call_location_service stopped successfully");
      await Workmanager().cancelByTag("fajar");
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
  Duration _calculateInitialDelay(int seconds) {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    final midnight = DateTime(nextDay.year, nextDay.month, nextDay.day);
    final delay = midnight.difference(now) + Duration(seconds: seconds);
    return delay;
  }

  Future<void> createDummyDataService() async {
    print("\t ---------> createDummyDataService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'create_dummy_data_service',
      'create_dummy_data_service',
      tag: 'create',
      initialDelay: _calculateInitialDelay(1),
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
      initialDelay: _calculateInitialDelay(32400),
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
      initialDelay: _calculateInitialDelay(21600),
      frequency: const Duration(hours: 8),
      // initialDelay: const Duration(seconds: 100),
      // frequency: const Duration(minutes: 15),
    );
  }

  Future<void> fajarPrayer() async {
    print("\t ---------> Fajar Prayer Service() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'fajar_prayer_service',
      'fajar_prayer_service',
      tag: 'fajar',
      initialDelay: _calculateInitialDelay(18000), // 5am
      // initialDelay: const Duration(seconds: 10),
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
      initialDelay: _calculateInitialDelay(54000), // 3pm
      // initialDelay: const Duration(seconds: 10),
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
      initialDelay: _calculateInitialDelay(68400), // 7pm
      // initialDelay: const Duration(seconds: 10),
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
      initialDelay: _calculateInitialDelay(72000), // 8pm
      // initialDelay: const Duration(seconds: 10),
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
      initialDelay: _calculateInitialDelay(79200), // 10pm
      // initialDelay: const Duration(seconds: 10),
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
