import 'package:everyday_chronicles/src/features/authentication/screens/mail_verification/mail_verification.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeScreen())
        : user.emailVerified
            ? Get.offAll(() => const BottomNavigationBarWidget())
            : Get.offAll(() => const MailVerificationScreen());
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
        "Verify your Email to Login. Thanks",
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
      firebaseUser.value != null
          ? firebaseUser.value!.emailVerified
              ? Get.off(() => const BottomNavigationBarWidget())
              : Get.off(() => const MailVerificationScreen())
          : Get.to(() => const WelcomeScreen());

      Get.snackbar(
        "Successfully",
        "Log In Successfully",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
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

  Future<void> logout() async => await _auth.signOut();
}
