import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:everyday_chronicles/src/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var otpController = Get.put(OTPController());
    var otp;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(myDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myOtpTitle,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 80.0,
              ),
            ),
            Text(myOtpSubTitle.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40.0),
            Text(
              "${myOtpMessage}abdullah.dewan@gmail.com",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20.0),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                //print("OTP is => $code");
                otp = code;
                //OTPController.instance.verifyOTP(otp);
              },
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //OTPController.instance.verifyOTP(otp);
                },
                child: const Text(myNextText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
