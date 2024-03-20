import 'package:everyday_chronicles/src/features/authentication/screens/reset_password/reset_password_screen.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  //GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail(String email) async {
    try {
      await AuthenticationRepository.instance
          .sendPasswordResetLink(email);

      Get.to(() => ResetPasswordScreen(email: email));
    } catch (e) {
      //print exception occurs here
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      await AuthenticationRepository.instance.sendPasswordResetLink(email);
    } catch (e) {
      //print exception occurs here
    }
  }
}
