import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/widgets/avatar.dart';

/// The user's own profile entry followed by everyone who has written to them.
class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profiles = Get.find();
    final PostcardController postcards = Get.find();

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(30),
      child: RefreshIndicator(
        onRefresh: () => postcards.loadAll(Get.find<AuthController>().user.uid),
        child: Obx(() {
          final me = profiles.profile;
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: Avatar(me.avatar, size: 60),
                title: Text(
                  me.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  me.location,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                onTap: () => Get.toNamed(Routes.myProfile),
              ),
              const SizedBox(height: 30),
              const Divider(),
              for (final friend in postcards.friends)
                ListTile(
                  leading: Avatar(friend.avatar),
                  title: Text(
                    friend.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    friend.location,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
