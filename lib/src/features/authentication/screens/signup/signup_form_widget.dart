import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(vertical: myFormHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  label: Text(myFullName),
                  hintText: myHintFullName,
                  prefixIcon: Icon(Icons.person_outline_rounded)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text(myEmail),
                  hintText: myHintEmail,
                  prefixIcon: Icon(Icons.email_outlined)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  label: Text(myPhone),
                  hintText: myHintPhone,
                  prefixIcon: Icon(Icons.phone_outlined)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                  label: Text(myPassword),
                  hintText: myHintPassword,
                  prefixIcon: Icon(Icons.lock_outline)
              ),
            ),
            const SizedBox(height: myFormHeight - 20),
            TextFormField(
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
                onPressed: () {},
                child: Text(mySignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}