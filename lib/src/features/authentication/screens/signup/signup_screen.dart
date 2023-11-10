import 'package:everyday_chronicles/src/common_widgets/form/form_header_widget.dart';
import 'package:everyday_chronicles/src/constants/colors.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/signup/signup_form_widget.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/form/form_footer_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(myDefaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: mySignupImage,
                  title: mySignupTitle,
                  subtitle: mySignupSubTitle,
                ),
                SignupFormWidget(),
                FormFooterWidget(
                  haveAnAccount: myAlreadyHaveAnAccount,
                  logOrSign: myLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

