import 'package:everyday_chronicles/src/features/core/screens/home/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../controllers/login_controller.dart';
import '../forget_password/forget_password_options/forget_password_btn_widget.dart';
import '../forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final loginController = Get.put(LogInController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = false; // Track password visibility
  // Create a function to toggle password visibility
  void togglePasswordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: myFormHeight - 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: loginController.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: myEmail,
                hintText: myHintEmail,
                border: OutlineInputBorder(),
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
              controller: loginController.password,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !passwordVisible, // Hide the password if _passwordVisible is false
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: Text(
                  myForgetPassword,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //Get.offAll( () => const BottomNavigationBarWidget());
                  if(_formKey.currentState!.validate()){
                    LogInController.instance.loginUser(loginController.email.text.trim(), loginController.password.text.trim());
                  }
                },
                child: Text(myLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

