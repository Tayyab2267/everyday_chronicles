import 'package:everyday_chronicles/src/common_widgets/form/form_header_widget.dart';
import 'package:everyday_chronicles/src/constants/image_strings.dart';
import 'package:everyday_chronicles/src/constants/sizes.dart';
import 'package:everyday_chronicles/src/constants/text_strings.dart';
import 'package:everyday_chronicles/src/features/authentication/controllers/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common_widgets/button/back_button_widget.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  ForgetPasswordMailScreen({super.key});

  final controller = Get.put(ForgetPasswordController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define a function that returns the widget to navigate to
  // void _navigateToSendPasswordResetEmail() {
  //   Get.to(() => controller.sendPasswordResetEmail());
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(myDefaultSize),
            child: Column(
              children: [
                const BackButtonWidget(),
                const SizedBox(height: myDefaultSize * 3),
                const FormHeaderWidget(
                  image: myForgetPasswordImage,
                  title: myForgetPassword,
                  subtitle: myForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: myFormHeight),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text(myEmail),
                          hintText: myHintEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
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
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //Get.offAll( () => const BottomNavigationBarWidget());
                            if(_formKey.currentState!.validate()){
                              ForgetPasswordController.instance.sendPasswordResetEmail(controller.email.text.trim());
                            }
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
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
