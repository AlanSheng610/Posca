import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/onboarding_controller.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  static const _avatarRadius = 80.0;

  Future<void> _next() async {
    final OnboardingController onboarding = Get.find();
    onboarding.avatar = await FluttermojiFunctions().encodeMySVGtoString();
    Get.toNamed(Routes.onboardingInterests);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: transparentAppBar(),
      backgroundColor: AppColors.onboarding,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Stack(
          children: [
            const Positioned(
              top: 100,
              child: Text(
                'Create your\nown persona',
                style: AppTextStyles.pageTitle,
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Center(
                child: FluttermojiCircleAvatar(
                  radius: _avatarRadius,
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            Positioned(
              top: 320,
              child: FluttermojiCustomizer(
                scaffoldWidth: size.width * 0.9,
                scaffoldHeight: size.height * 0.5,
                autosave: true,
                theme: FluttermojiThemeData(
                  primaryBgColor: AppColors.onboarding,
                  labelTextStyle: const TextStyle(color: Colors.white),
                  boxDecoration: const BoxDecoration(boxShadow: [BoxShadow()]),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: IconButton(
                  onPressed: _next,
                  icon: const Icon(Icons.check, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
