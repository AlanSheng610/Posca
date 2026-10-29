import 'package:flutter/material.dart';
import 'package:posca/app/theme.dart';

/// Dark page with a large question title, shared by the onboarding steps.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.children,
    this.titleSpacing = 200,
  });

  final String title;
  final List<Widget> children;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: transparentAppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.onboarding,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(title, style: AppTextStyles.pageTitle),
            SizedBox(height: titleSpacing),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// The outlined "→" button that advances to the next onboarding step.
class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
        ),
        child: const Icon(Icons.arrow_right_alt, color: Colors.white, size: 30),
      ),
    );
  }
}
