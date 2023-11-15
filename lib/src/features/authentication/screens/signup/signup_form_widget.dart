import 'package:everyday_chronicles/src/features/authentication/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final signupController = Get.put(SignUpController());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: myFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: signupController.fullName,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  label: Text(myFullName),
                  hintText: myHintFullName,
                  prefixIcon: Icon(Icons.person_outline_rounded)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text(myEmail),
                  hintText: myHintEmail,
                  prefixIcon: Icon(Icons.email_outlined)
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                // Use a regular expression to check if the entered text is a valid email address
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null; // Return null if the validation is successful
              },
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.phoneNo,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  label: Text(myPhone),
                  hintText: myHintPhone,
                  prefixIcon: Icon(Icons.phone_outlined)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.password,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                  label: Text(myPassword),
                  hintText: myHintPassword,
                  prefixIcon: Icon(Icons.lock_outline)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.confirmPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                  label: Text(myConfirmPassword),
                  hintText: myHintPassword,
                  prefixIcon: Icon(Icons.lock_outline)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    SignUpController.instance.registerUser(signupController.email.text.trim(), signupController.password.text.trim());
                  }
                },
                child: Text(mySignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}