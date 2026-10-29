import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/models/user_profile.dart';
import 'package:posca/widgets/info_row.dart';
import 'package:posca/widgets/pickers.dart';

/// Edits a copy of the profile; changes are saved only on confirm.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _profiles = Get.find();
  late UserProfile _draft = _profiles.profile;
  late final _nameController = TextEditingController(text: _draft.name);
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editBio() async {
    final bio =
        await Get.toNamed<String>(Routes.editBio, arguments: _draft.bio);
    if (bio != null) setState(() => _draft = _draft.copyWith(bio: bio));
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _profiles.save(_draft.copyWith(name: _nameController.text.trim()));
      Get.back();
    } catch (e) {
      Get.snackbar('Error updating profile', e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.15),
            Container(
              padding: const EdgeInsets.all(30),
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: AppColors.panel,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name', style: AppTextStyles.sectionTitle),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Divider(color: Colors.black, height: 30),
                  const Text('Bio', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: _editBio,
                    child: SizedBox(
                      width: double.infinity,
                      child: ExpandableText(
                        _draft.bio.isEmpty ? 'Tap to add a bio' : _draft.bio,
                        style: AppTextStyles.value.copyWith(fontSize: 15),
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 3,
                        linkColor: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.black, height: 30),
                  InfoRow(
                    label: 'Gender',
                    value: _draft.gender,
                    onTap: () => showGenderPicker(
                      context,
                      onSubmit: (gender) => setState(
                        () => _draft = _draft.copyWith(gender: gender),
                      ),
                    ),
                  ),
                  InfoRow(
                    label: 'Birthday',
                    value: _draft.birthdate,
                    onTap: () => showBirthdatePicker(
                      context,
                      onSubmit: (date) => setState(
                        () => _draft = _draft.copyWith(birthdate: date),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
