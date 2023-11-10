import 'package:everyday_chronicles/src/common_widgets/form/form_header_widget.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(myDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: myDefaultSize * 4),
                const FormHeaderWidget(
                  image: myForgetPasswordImage,
                  title: myForgetPassword,
                  subtitle: myForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: myFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text(myEmail),
                          hintText: myHintEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to( () => const OTPScreen());
                          },
                          child: const Text(myNextText),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
