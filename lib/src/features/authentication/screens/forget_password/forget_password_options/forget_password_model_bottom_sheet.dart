import 'package:everyday_chronicles/src/features/authentication/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import 'forget_password_btn_widget.dart';

class ForgetPasswordScreen{
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(),
      builder: (context) => Container(
        padding: const EdgeInsets.all(myDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              myForgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              myForgetPasswordSubTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mail_outline_rounded,
              title: myEmail,
              subTitle: myResetViaEmail,
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ForgetPasswordMailScreen());
              },
            ),
            const SizedBox(height: 20.0),
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mobile_friendly_rounded,
              title: myPhone,
              subTitle: myResetViaPhone,
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}