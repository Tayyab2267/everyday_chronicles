import 'package:everyday_chronicles/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../controllers/login_controller.dart';

class LoginFormFooterWidget extends StatelessWidget {
  const LoginFormFooterWidget({super.key,
    required this.haveAnAccount,
    required this.logOrSign,
  });

  final String haveAnAccount, logOrSign;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text("OR"),
        // const SizedBox(height: myFormHeight - 20),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     icon: const Image(
        //       image: AssetImage(myGoogleLogoImage),
        //       width: 20.0,
        //     ),
        //     onPressed: () {
        //       //controller.googleSignIn();
        //       print("Google Sign in Button clicked");
        //     },
        //     label: const Text(mySignInWithGoogle),
        //   ),
        // ),
        // const SizedBox(height: myFormHeight - 20),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Get.to( () => const SignupScreen());
          },
          child: Text.rich(
            TextSpan(
              text: haveAnAccount,
              style: Theme.of(context).textTheme.titleSmall,
              children: [
                TextSpan(
                    text: logOrSign,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.blue)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}