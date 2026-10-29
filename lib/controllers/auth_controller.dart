import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:posca/app/routes.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/controllers/profile_controller.dart';

/// Signs users in and out and routes them to the right first screen.
class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final ProfileController _profiles = Get.find();
  final PostcardController _postcards = Get.find();
  StreamSubscription<User?>? _authSubscription;

  User get user => _auth.currentUser!;

  @override
  void onReady() {
    super.onReady();
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      _postcards.clear();
      Get.offAllNamed(Routes.login);
      return;
    }
    try {
      final hasProfile = await _profiles.load(user.uid);
      if (hasProfile) {
        await enterApp();
      } else {
        Get.offAllNamed(Routes.onboardingName);
      }
    } catch (e) {
      Get.snackbar('Could not load your account', e.toString());
    }
  }

  /// Loads the user's postcards and opens the home screen.
  Future<void> enterApp() async {
    await _postcards.loadAll(user.uid);
    Get.offAllNamed(Routes.home);
  }

  /// Creates an account. Navigation happens via the auth state listener.
  Future<void> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error creating account', 'Please fill in all fields');
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error creating account', e.message ?? e.code);
    }
  }

  /// Signs in. Navigation happens via the auth state listener.
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error logging in', 'Please fill in all fields');
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error logging in', e.message ?? e.code);
    }
  }

  Future<void> logout() => _auth.signOut();
}
