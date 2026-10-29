import 'package:get/get.dart';
import 'package:posca/data/firestore_refs.dart';
import 'package:posca/models/send_config.dart';
import 'package:posca/models/user_profile.dart';

/// Holds the signed-in user's profile and send settings.
class ProfileController extends GetxController {
  final _profile = Rxn<UserProfile>();
  SendConfig sendConfig = SendConfig.initial;

  /// The signed-in user's profile. Only valid after [load] returned true.
  UserProfile get profile => _profile.value!;

  /// Loads the user's profile and send config.
  ///
  /// Returns false if the user has no profile yet and must be onboarded.
  Future<bool> load(String uid) async {
    final results = await Future.wait([
      FirestoreRefs.user(uid).get(),
      FirestoreRefs.sendConfig(uid).get(),
    ]);
    final profileDoc = results[0];
    final sendConfigDoc = results[1];

    if (!profileDoc.exists) return false;
    _profile.value = UserProfile.fromMap(uid, profileDoc.data()!);
    sendConfig = sendConfigDoc.exists
        ? SendConfig.fromMap(sendConfigDoc.data()!)
        : SendConfig.initial;
    return true;
  }

  Future<void> save(UserProfile profile) async {
    await FirestoreRefs.user(profile.uid).set(profile.toMap());
    _profile.value = profile;
  }

  Future<void> updateLocation({
    required String city,
    required String country,
  }) async {
    final updated = profile.copyWith(city: city, country: country);
    await FirestoreRefs.user(updated.uid).update({
      'city': city,
      'country': country,
    });
    _profile.value = updated;
  }

  Future<void> recordPublicSend() async {
    final config = SendConfig(
      lastPublicSendAt: DateTime.now(),
      languages: sendConfig.languages,
      locations: sendConfig.locations,
      gender: sendConfig.gender,
      minAge: sendConfig.minAge,
      maxAge: sendConfig.maxAge,
    );
    await FirestoreRefs.sendConfig(profile.uid).set(config.toMap());
    sendConfig = config;
  }

  Future<UserProfile?> fetchProfile(String uid) async {
    final doc = await FirestoreRefs.user(uid).get();
    return doc.exists ? UserProfile.fromMap(uid, doc.data()!) : null;
  }
}
