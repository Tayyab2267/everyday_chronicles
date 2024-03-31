import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

// String getCurrentDate() {
//   DateTime now = DateTime.now();
//   String formattedDate = '${now.day} ${now.month} ${now.year} ${now.hour}:${now.minute}';
//   return formattedDate;
// }

// callbackDispatcher function used to execute task.
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     // here I used switch statement because we have multiple tasks to run in background.
//     String emailBox = inputData?['string'];
//     switch (taskName) {
//       case 'task_one_create_dummy_day_data':
//         print("\n\n\t ........................................\n\n");
//         print("\n\n\t ............. Task no 01 ................\n\n");
//         print("\n\n\t ............. $emailBox ................\n\n");
//         print("\n\n\t ........................................\n\n");
//
//         // create dummy list for Hive Day Data
//         List<dynamic> dummyList = [
//           Icons.sentiment_satisfied,
//           "Title Of Day",
//           "Subtitle which is dummy text of the day. it will change later when a user will complete its day."
//         ];
//
//         //open existing user HiveBox
//         var currentUserHiveBox = await Hive.openBox(emailBox);
//         print("Box  created");
//         final myBox = Hive.box(emailBox);
//         print("Box opened");
//         myBox.put(getCurrentDate, dummyList);
//         print("Box put");
//         print(myBox.get(getCurrentDate));
//         print("Box get");
//         break;
//
//       default:
//     }
//     return Future.value(true);
//   });
// }

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
    if(user == null){
      Get.offAll(() => const WelcomeScreen());
    } else {
      if(user.emailVerified){
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

  // Future<void> phoneAuth(String phoneNo) async {
  //   await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNo,
  //       verificationCompleted: (credential) async {
  //         await _auth.signInWithCredential(credential);
  //       },
  //       codeSent: (verificationId, resendToken) {
  //         this.verificationId.value = verificationId;
  //       },
  //       codeAutoRetrievalTimeout: (verificationId) {
  //         this.verificationId.value = verificationId;
  //       },
  //       verificationFailed: (e) {
  //         if (e.code == 'invalid-phone-number') {
  //           Get.snackbar('Error', 'The provided phone number is not valid.');
  //         } else {
  //           Get.snackbar('Error', 'Something went wrong. Try again.');
  //         }
  //       });
  // }

  // Future<bool> verifyOTP(String otp) async {
  //   var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(
  //       verificationId: verificationId.value, smsCode: otp));
  //
  //   return credentials.user != null ? true : false;
  // }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //firebaseUser.value != null ? Get.offAll(() => const BottomNavigationBarWidget()) : Get.to(() => const WelcomeScreen());
      //sendEmailVerification();
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

          // Hive.openBox(email) creates a new HiveBox
          var currentUserHiveBox = await Hive.openBox(email);
          print("Hive Box is created\nName: $email");

          //WorkManager background service initialization to run callbackDispatcher function
          // await Workmanager().initialize(
          //   callbackDispatcher,
          //   // isInDebugMode true means it will shows Notification on mobile
          //   // to confirm that functions work properly
          //   isInDebugMode: true,
          // );

          // Background service to create and store dummy day data
          // in the Hive database everyday
          // await Workmanager().registerPeriodicTask(
          //   'task_one_create_dummy_day_data',
          //   'task_one_create_dummy_day_data',
          //   frequency: const Duration(minutes: 16),
          //   inputData: {
          //     'string': email,
          //   },
          // );


          // Workmanager().cancelAll();

          // await Workmanager().registerOneOffTask(
          //   uniqueId,
          //   task,
          //   initialDelay: const Duration(seconds: 10),
          // );

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

  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await userAccount?.authentication;
  //     final credentials = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
  //     return await _auth.signInWithCredential(credentials);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Something went wrong: $e");
  //       return null;
  //     }
  //   }
  // }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }
}
