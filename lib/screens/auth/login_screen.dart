import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/screens/auth/auth_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    return AuthForm(
      title: 'Login',
      onSubmit: auth.login,
      switchPrompt: "Don't have an account? ",
      switchLabel: 'Register',
      onSwitch: () => Get.offNamed(Routes.signUp),
    );
  }
}
