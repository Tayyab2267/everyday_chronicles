
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LogInController extends GetxController{
  static LogInController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  // call this function from design and it will do the rest
  Future<void> loginUser(String email, String password) async {
    final auth = AuthenticationRepository.instance;
    await auth.loginWithEmailAndPassword(email, password);
    auth.setInitialScreen(auth.firebaseUser as User?);
  }

}