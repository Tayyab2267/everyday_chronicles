import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

class OTPController extends GetxController{
  static OTPController get instance => Get.find();

  // void verifyOTP(String otp) async{
  //   var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
  //   isVerified ? Get.offAll(const BottomNavigationBarWidget()) : Get.back();
  // }
}