import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:everyday_chronicles/src/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/theme/widget_themes/elevated_button_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: const AssetImage(myLoginImage),
                  height: size.height * 0.25,
                ),
                Text(
                  myLoginTitle,
                  style: isDarkMode
                      ? MyTextTheme.darkTextTheme.headline1
                      : MyTextTheme.lightTextTheme.headline1,
                ),
                Text(
                  myLoginSubTitle,
                  style: isDarkMode
                      ? MyTextTheme.darkTextTheme.bodyText1
                      : MyTextTheme.lightTextTheme.bodyText1,
                ),
                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: myFormHeight - 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.person_outline_outlined),
                            labelText: myEmail,
                            hintText: myHintEmail,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: myFormHeight - 20),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: myPassword,
                            hintText: myHintPassword,
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                          ),
                        ),
                        const SizedBox(height: myFormHeight - 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(myForgetPassword),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButtonTheme(
                            data: isDarkMode
                                ? MyElevatedButtonTheme.darkElevatedButtonTheme
                                : MyElevatedButtonTheme
                                    .lightElevatedButtonTheme,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(myLogin.toUpperCase()),
                            ),
                          ),
                        ),
                      ],
                    ),
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
