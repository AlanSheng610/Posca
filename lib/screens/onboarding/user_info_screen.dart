import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/onboarding_controller.dart';
import 'package:posca/screens/onboarding/onboarding_scaffold.dart';
import 'package:posca/widgets/pickers.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final OnboardingController _onboarding = Get.find();

  bool get _isComplete =>
      _onboarding.birthdate.isNotEmpty &&
      _onboarding.gender.isNotEmpty &&
      _onboarding.languages.isNotEmpty;

  Future<void> _pickLanguages() async {
    final result = await Get.toNamed<List<String>>(
      Routes.languagePicker,
      arguments: _onboarding.languages,
    );
    if (result != null) setState(() => _onboarding.languages = result);
  }

  void _next() {
    if (_isComplete) {
      Get.toNamed(Routes.onboardingAvatar);
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: 'Tell us about yourself!',
      children: [
        _Field(
          label: 'Birthday',
          value: _onboarding.birthdate,
          onTap: () => showBirthdatePicker(
            context,
            onSubmit: (date) => setState(() => _onboarding.birthdate = date),
          ),
        ),
        const Divider(height: 25),
        _Field(label: 'Language', value: '', onTap: _pickLanguages),
        for (final language in _onboarding.languages)
          Text(language, style: const TextStyle(color: Colors.white)),
        const Divider(height: 25),
        _Field(
          label: 'Gender',
          value: _onboarding.gender,
          onTap: () => showGenderPicker(
            context,
            onSubmit: (gender) => setState(() => _onboarding.gender = gender),
          ),
        ),
        NextButton(onPressed: _next),
      ],
    );
  }
}

/// A label with either its current value or a "+" button to set it.
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.sectionTitle),
        if (value.isEmpty)
          IconButton(onPressed: onTap, icon: const Icon(Icons.add))
        else
          TextButton(
            onPressed: onTap,
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}
