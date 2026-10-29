import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF2E2F30);
  static const onboarding = Color(0xFF212121);
  static const sheet = Color(0xFF303030);
  static const panel = Color(0x19D9D9D9);
  static const chip = Color(0x4CD9D9D9);
  static const input = Color(0xFF303030);
  static const mutedText = Color(0xCCFFFFFF);

  /// Black or white, whichever reads better on [background].
  static Color onColor(Color background) =>
      ThemeData.estimateBrightnessForColor(background) == Brightness.dark
          ? Colors.white
          : Colors.black;
}

abstract final class AppTextStyles {
  static const pageTitle = TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const sectionTitle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.36,
  );

  static const label = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.24,
  );

  static const value = TextStyle(
    color: AppColors.mutedText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.24,
  );
}

/// Transparent app bar with white icons, used on the dark full-bleed pages.
AppBar transparentAppBar({
  List<Widget>? actions,
  Widget? leading,
  double? leadingWidth,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    automaticallyImplyLeading: leading == null,
    leading: leading,
    leadingWidth: leadingWidth,
    actions: actions,
  );
}
