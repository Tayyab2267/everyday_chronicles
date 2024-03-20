
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final fullName = TextEditingController();
  final email = TextEditingController();
  //final phoneNo = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  
  // call this function from design and it will do the rest
  Future<void> registerUser(String email, String password) async {
    final auth =  AuthenticationRepository.instance;
    await auth.createUserWithEmailAndPassword(email, password);
    auth.setInitialScreen(auth.firebaseUser as User?);
  }

  // void phoneAuthentication(String phoneNo){
  //   AuthenticationRepository.instance.phoneAuth(phoneNo);
  // }

}