import 'package:flutter/material.dart';

import '../../constants/image_strings.dart';
import '../../constants/sizes.dart';
import '../../constants/text_strings.dart';

class FormFooterWidget extends StatelessWidget {
  const FormFooterWidget({super.key,
    required this.haveAnAccount,
    required this.logOrSign,
  });

  final String haveAnAccount, logOrSign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: myFormHeight - 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(myGoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () {},
            label: const Text(mySignInWithGoogle),
          ),
        ),
        const SizedBox(height: myFormHeight - 20),
        TextButton(
          onPressed: () {},
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