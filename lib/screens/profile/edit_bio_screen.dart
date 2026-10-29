import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/theme.dart';

/// Takes the current bio as arguments and returns the edited bio.
class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key});

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  final _bioController = TextEditingController(text: Get.arguments as String);

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: transparentAppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: Get.back,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Get.back(result: _bioController.text.trim()),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 150, 20, 10),
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bio', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 25),
            TextField(
              controller: _bioController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              minLines: 5,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Your bio',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
