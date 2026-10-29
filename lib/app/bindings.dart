import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:posca/controllers/auth_controller.dart';
import 'package:posca/controllers/postcard_controller.dart';
import 'package:posca/controllers/profile_controller.dart';

/// App-wide controllers. Order matters: later ones look up earlier ones.
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(), permanent: true);
    Get.put(PostcardController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(FluttermojiController(), permanent: true);
  }
}
