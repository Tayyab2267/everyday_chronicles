import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      if (user.emailVerified) {
        Get.offAll(() => const BottomNavigationBarWidget());
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
          createDummyDayDataService();
          fetchWeatherConditionService();
          trackUserLocation();
          trackCallLocation();

          // Open home Screen
          Get.off(() => const BottomNavigationBarWidget());
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
    Workmanager().cancelAll();
    print(" -----> task_one Background service Stopped .....");
    print(" -----> task_two Background service Stopped .....");

    // try{
    //   Workmanager().cancelByTag("task_three_track_step_counter_service");
    //   print(" -----> track Step counter Background service Stopped .....");
    // }catch(ex){
    //   print("--> Exception: ${ex.toString()} .....");
    // }



    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }

  // Function to calculate the initial delay until 12:00 AM of the next day
  Duration _calculateInitialDelay() {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    final midnight = DateTime(nextDay.year, nextDay.month, nextDay.day);
    final delay = midnight.difference(now);
    return delay;
  }

  // Function to calculate the initial delay until 6:00 AM of the next day
  Duration _calculateInitialDelaySix() {
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    final sixAM = DateTime(nextDay.year, nextDay.month, nextDay.day, 6, 0, 0);
    final delay = sixAM.difference(now);
    return delay;
  }

  Future<void> createDummyDayDataService() async {
    print("\t ---------> createDummyDayDataService() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'task_one_create_dummy_data_service',
      'task_one_create_dummy_data_service',
      initialDelay: _calculateInitialDelay(),
      frequency: const Duration(days: 1),
    );
  }

  Future<void> fetchWeatherConditionService() async {
    print("\t ---------> fetchWeatherConditionService() function called");
    print(
        "--> Time _calculateInitialDelaySix(): ${_calculateInitialDelaySix().toString()}");
    // background service code
    await Workmanager().registerPeriodicTask(
      'task_two_fetch_weather_condition_service',
      'task_two_fetch_weather_condition_service',
      initialDelay: _calculateInitialDelaySix(),
      //initialDelay: const Duration(seconds: 15),
      frequency: const Duration(hours: 8),
    );
  }

  Future<void> trackUserLocation() async {
    print("\t ---------> trackUserLocation() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'task_three_track_user_location_service',
      'task_three_track_user_location_service',
      // initialDelay: _calculateInitialDelaySix(),
      initialDelay: const Duration(seconds: 10),
      frequency: const Duration(minutes: 15),
    );
  }

  Future<void> trackCallLocation() async {
    print("\t ---------> trackCallLocation() function called");
    // background service code
    await Workmanager().registerPeriodicTask(
      'task_four_track_call_location_service',
      'task_four_track_call_location_service',
      initialDelay: _calculateInitialDelaySix(),
      //initialDelay: const Duration(seconds: 30),
      frequency: const Duration(minutes: 16),
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
