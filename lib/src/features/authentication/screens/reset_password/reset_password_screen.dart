import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/features/authentication/controllers/forget_password_controller.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/image_strings.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(myDefaultSize),
          child: Column(
            children: [
              const Image(image: AssetImage(myForgetPasswordImage), width: 30),
              const SizedBox(height: myDefaultSize),
              Text(email,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: myDefaultSize),
              Text("Password Reset Email Sent",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: myDefaultSize),
              Text("We have sent you a link to reset your password.",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: myDefaultSize),
              SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen()), child: const Text("Done")),
              ),
              const SizedBox(height: myDefaultSize),
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email), child: const Text("Resend Email")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
