import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/onboarding_controller.dart';
import 'package:posca/screens/onboarding/onboarding_scaffold.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final OnboardingController _onboarding = Get.find();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }
    _onboarding.name = name;
    Get.toNamed(Routes.onboardingInfo);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: 'What should we call you?',
      titleSpacing: 250,
      children: [
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          onSubmitted: (_) => _next(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.input,
            hintText: 'Your nickname',
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_right_alt),
              onPressed: _next,
            ),
            suffixIconColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
