import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/app/theme.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/widgets/avatar.dart';
import 'package:posca/widgets/info_row.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profiles = Get.find();
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: transparentAppBar(
        actions: [
          TextButton(
            onPressed: Get.find<AuthController>().logout,
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Obx(() {
        final profile = profiles.profile;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Avatar(profile.avatar, size: 105),
              Text(
                profile.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              if (profile.location.isNotEmpty) ...[
                const SizedBox(height: 15),
                Chip(
                  label: Text(profile.location, style: AppTextStyles.label),
                  backgroundColor: AppColors.chip,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
              ],
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () => Get.toNamed(Routes.editProfile),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: width * 0.7,
                child: ExpandableText(
                  profile.bio,
                  style: AppTextStyles.value,
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 3,
                  linkColor: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(30),
                width: width * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LinkRow(
                      label: 'My Collection',
                      onTap: () => Get.toNamed(Routes.collection),
                    ),
                    const Divider(color: Colors.black, height: 10),
                    const Text('About', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 10),
                    InfoRow(label: 'Gender', value: profile.gender),
                    InfoRow(label: 'Birthdate', value: profile.birthdate),
                    InfoRow(
                      label: 'Languages',
                      value: profile.spokenLanguages.join(', '),
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),
                    const Text('Interests', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (final interest in profile.interests)
                          Chip(
                            label: Text(interest),
                            backgroundColor:
                                const Color.fromARGB(255, 236, 233, 233),
                            labelStyle: const TextStyle(color: Colors.black45),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
