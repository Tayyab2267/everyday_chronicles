import 'package:everyday_chronicles/src/features/authentication/controllers/signup_controller.dart';
import 'package:everyday_chronicles/src/features/authentication/models/user_model.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({
    super.key,
  });

  @override
  State<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final signupController = Get.put(SignUpController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisible = false; // Track password visibility
  bool confirmPasswordVisible = false; // Track confirm password visibility

  // Create a function to toggle password visibility
  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  // Create a function to toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    setState(() {
      confirmPasswordVisible = !confirmPasswordVisible;
    });
  }

  InputDecoration buildPasswordInputDecoration() {
    return InputDecoration(
      label: const Text(myPassword),
      hintText: myHintPassword,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onPressed: togglePasswordVisibility,
      ),
    );
  }

  InputDecoration buildConfirmPasswordInputDecoration(bool isVisible) {
    return InputDecoration(
      label: const Text(myConfirmPassword),
      hintText: myHintPassword,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onPressed: toggleConfirmPasswordVisibility,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  prefixIcon: Icon(Icons.person_outline_rounded)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null; // Return null if the validation is successful
              },
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text(myEmail),
                  hintText: myHintEmail,
                  prefixIcon: Icon(Icons.email_outlined)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                // Use a regular expression to check if the entered text is a valid email address
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null; // Return null if the validation is successful
              },
            ),
            const SizedBox(height: myFormHeight - 20),
            // TextFormField(
            //   controller: signupController.phoneNo,
            //   keyboardType: TextInputType.phone,
            //   decoration: const InputDecoration(
            //       label: Text(myPhone),
            //       hintText: myHintPhone,
            //       prefixIcon: Icon(Icons.phone_outlined)
            //   ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter your phone number';
            //     }
            //     return null; // Return null if the validation is successful
            //   },
            // ),
            // const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.password,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !passwordVisible,
              // Hide the password if _passwordVisible is false
              decoration: buildPasswordInputDecoration(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                // Check if password contains at least one lowercase letter
                if (!RegExp(r'[a-z]').hasMatch(value)) {
                  return 'Password must contain one lowercase letter';
                }
                // Check if password contains at least one uppercase letter
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return 'Password must contain one uppercase letter';
                }
                // Check if password contains at least one digit
                if (!RegExp(r'\d').hasMatch(value)) {
                  return 'Password must contain one digit';
                }
                // Check if password contains at least one special character
                if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                  return 'Password must contain one special character';
                }
                // Check if password length is at least 8 characters
                if (value.length < 8) {
                  return 'Password must be 8 characters long';
                }
                return null; // Return null if the validation is successful
              },
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              controller: signupController.confirmPassword,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !confirmPasswordVisible,
              // Hide the confirm password if _confirmPasswordVisible is false
              decoration:
                  buildConfirmPasswordInputDecoration(confirmPasswordVisible),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the confirm password';
                }
                // Compare the confirm password with the original password
                if (value != signupController.password.text) {
                  return 'Passwords do not match';
                }
                return null; // Return null if the validation is successful
              },
            ),
            const SizedBox(height: myFormHeight - 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //SignUpController.instance.registerUser(signupController.email.text.trim(), signupController.password.text.trim());
                    //SignUpController.instance.phoneAuthentication(signupController.phoneNo.text.trim());
                    //Get.to(() => const OTPScreen());

                    final user = UserModel(
                      fullName: signupController.fullName.text.trim(),
                      email: signupController.email.text.trim(),
                      password: signupController.password.text.trim(),
                    );
                    SignUpController.instance.createUser(user);
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
