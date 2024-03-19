import 'package:everyday_chronicles/src/common_widgets/form/form_header_widget.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:flutter/material.dart';
import '../../../../common_widgets/button/back_button_widget.dart';
import '../../../../constants/colors.dart';
import 'login_form_footer_widget.dart';
import 'login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? myBackgroundDarkColor : myWhiteColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(myDefaultSize),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButtonWidget(),
                FormHeaderWidget(
                  image: myLoginImage,
                  title: myLoginTitle,
                  subtitle: myLoginSubTitle,
                ),
                LoginForm(),
                LoginFormFooterWidget(
                  haveAnAccount: myDontHaveAnAccount,
                  logOrSign: mySignup,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

