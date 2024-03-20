import 'package:everyday_chronicles/src/features/authentication/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class SignupFormFooterWidget extends StatelessWidget {
  const SignupFormFooterWidget({super.key,
    required this.haveAnAccount,
    required this.logOrSign,
  });

  final String haveAnAccount, logOrSign;

  @override
  Widget build(BuildContext context) {
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
        //     onPressed: () {},
        //     label: const Text(mySignInWithGoogle),
        //   ),
        // ),
        // const SizedBox(height: myFormHeight - 20),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Get.to( () => const LoginScreen());
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