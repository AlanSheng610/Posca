import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/screens/auth/auth_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    return AuthForm(
      title: 'Register',
      onSubmit: auth.register,
      switchPrompt: 'Already have an account? ',
      switchLabel: 'Login',
      onSwitch: () => Get.offNamed(Routes.login),
    );
  }
}
