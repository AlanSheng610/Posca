import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:posca/constants/interests.dart';
import 'package:posca/controllers/onboarding_controller.dart';
import 'package:posca/screens/onboarding/onboarding_scaffold.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final OnboardingController _onboarding = Get.find();
  final List<String> _interests = [...kInterests];
  List<String> _selected = [];
  bool _saving = false;

  Future<void> _addInterest() async {
    final controller = TextEditingController();
    final interest = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new interest'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter your interest'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (interest != null &&
        interest.isNotEmpty &&
        !_interests.contains(interest)) {
      setState(() => _interests.add(interest));
    }
  }

  Future<void> _finish() async {
    if (_selected.isEmpty) {
      Get.snackbar('Error', 'Please pick at least one interest');
      return;
    }
    setState(() => _saving = true);
    try {
      await _onboarding.finish(_selected);
    } catch (e) {
      Get.snackbar('Could not save your profile', e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      title: 'What are you interested in?',
      titleSpacing: 50,
      children: [
        MultiSelectContainer<String>(
          // Rebuild when an interest is added so the new chip shows up.
          key: ValueKey(_interests.length),
          prefix: MultiSelectPrefix(
            selectedPrefix: const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(Icons.check, color: Colors.white, size: 14),
            ),
          ),
          items: [
            for (final interest in _interests)
              MultiSelectCard(
                value: interest,
                label: interest,
                selected: _selected.contains(interest),
              ),
          ],
          onChange: (selected, _) => setState(() => _selected = selected),
        ),
        IconButton(
          onPressed: _addInterest,
          icon: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        _saving
            ? const Center(child: CircularProgressIndicator())
            : NextButton(onPressed: _finish),
      ],
    );
  }
}
