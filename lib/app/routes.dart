import 'package:get/get.dart';
import 'package:posca/controllers/compose_controller.dart';
import 'package:posca/controllers/onboarding_controller.dart';
import 'package:posca/screens/auth/login_screen.dart';
import 'package:posca/screens/auth/sign_up_screen.dart';
import 'package:posca/screens/compose/camera_screen.dart';
import 'package:posca/screens/compose/compose_screen.dart';
import 'package:posca/screens/home/home_screen.dart';
import 'package:posca/screens/onboarding/avatar_screen.dart';
import 'package:posca/screens/onboarding/interests_screen.dart';
import 'package:posca/screens/onboarding/language_picker_screen.dart';
import 'package:posca/screens/onboarding/name_screen.dart';
import 'package:posca/screens/onboarding/user_info_screen.dart';
import 'package:posca/screens/postcard/postcard_viewer_screen.dart';
import 'package:posca/screens/profile/collection_screen.dart';
import 'package:posca/screens/profile/edit_bio_screen.dart';
import 'package:posca/screens/profile/edit_profile_screen.dart';
import 'package:posca/screens/profile/my_profile_screen.dart';
import 'package:posca/screens/splash_screen.dart';

abstract final class Routes {
  /// Shown while the auth state is being resolved.
  static const splash = '/splash';

  static const login = '/login';
  static const signUp = '/sign-up';

  static const onboardingName = '/onboarding/name';
  static const onboardingInfo = '/onboarding/info';
  static const languagePicker = '/onboarding/languages';
  static const onboardingAvatar = '/onboarding/avatar';
  static const onboardingInterests = '/onboarding/interests';

  static const home = '/';
  static const camera = '/compose/camera';
  static const compose = '/compose';
  static const postcardViewer = '/postcards';

  static const myProfile = '/profile';
  static const editProfile = '/profile/edit';
  static const editBio = '/profile/edit/bio';
  static const collection = '/profile/collection';
}

final appPages = [
  GetPage(name: Routes.splash, page: () => const SplashScreen()),
  GetPage(name: Routes.login, page: () => const LoginScreen()),
  GetPage(name: Routes.signUp, page: () => const SignUpScreen()),
  GetPage(
    name: Routes.onboardingName,
    page: () => const NameScreen(),
    // Lives as long as the name screen, which stays at the bottom of the
    // onboarding stack.
    binding: BindingsBuilder.put(OnboardingController.new),
  ),
  GetPage(name: Routes.onboardingInfo, page: () => const UserInfoScreen()),
  GetPage(
    name: Routes.languagePicker,
    page: () => const LanguagePickerScreen(),
  ),
  GetPage(name: Routes.onboardingAvatar, page: () => const AvatarScreen()),
  GetPage(
    name: Routes.onboardingInterests,
    page: () => const InterestsScreen(),
  ),
  GetPage(name: Routes.home, page: () => const HomeScreen()),
  GetPage(
    name: Routes.camera,
    page: () => const CameraScreen(),
    transition: Transition.topLevel,
  ),
  GetPage(
    name: Routes.compose,
    page: () => const ComposeScreen(),
    binding: BindingsBuilder.put(ComposeController.new),
  ),
  GetPage(
    name: Routes.postcardViewer,
    page: () => const PostcardViewerScreen(),
  ),
  GetPage(name: Routes.myProfile, page: () => const MyProfileScreen()),
  GetPage(name: Routes.editProfile, page: () => const EditProfileScreen()),
  GetPage(name: Routes.editBio, page: () => const EditBioScreen()),
  GetPage(name: Routes.collection, page: () => const CollectionScreen()),
];
