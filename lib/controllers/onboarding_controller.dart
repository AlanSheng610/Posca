import 'package:get/get.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/models/user_profile.dart';

/// Collects profile details across the onboarding screens.
class OnboardingController extends GetxController {
  final AuthController _auth = Get.find();
  final ProfileController _profiles = Get.find();

  String name = '';
  String birthdate = '';
  String gender = '';
  List<String> languages = [];
  String avatar = '';

  Future<void> finish(List<String> interests) async {
    final user = _auth.user;
    await _profiles.save(
      UserProfile(
        uid: user.uid,
        name: name,
        avatar: avatar,
        birthdate: birthdate,
        gender: gender,
        spokenLanguages: languages,
        interests: interests,
      ),
    );
    await user.updateDisplayName(name);
    await _auth.enterApp();
  }
}
