import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/text_strings.dart';
import '../../controllers/mail_verification_controller.dart';

class MailVerificationScreen extends StatelessWidget {
  const MailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: myDefaultSize * 5,
            left: myDefaultSize,
            right: myDefaultSize,
            bottom: myDefaultSize * 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Removed const as Icon size is dynamic
              Icon(LineAwesomeIcons.envelope_open, size: 100),
              const SizedBox(height: myDefaultSize * 2),
              // Removed const as text style is dynamic
              Text("Verify your email address",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: myDefaultSize),
              Text(
                emailVerifSubtitle.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: myDefaultSize * 2),
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  child: const Text("Continue"),
                  onPressed: () {
                    controller.manuallyCheckEmailVerificationStatus();
                  },
                ),
              ),
              const SizedBox(height: myDefaultSize * 2),
              TextButton(
                onPressed: () {
                  controller.sendVerificationEmail();
                },
                child: const Text("Resend Email Link"),
              ),
              TextButton(
                onPressed: () {
                  AuthenticationRepository.instance.logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Use Flutter's built-in back arrow icon
                    Icon(Icons.arrow_back),
                    const SizedBox(width: 5),
                    const Text("back to login"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
