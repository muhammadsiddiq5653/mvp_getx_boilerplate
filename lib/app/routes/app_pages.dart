import 'package:get/get.dart';
import 'package:mvp_boilerplate/app/modules/home/binding.dart';
import 'package:mvp_boilerplate/app/modules/home/view.dart';
import 'package:mvp_boilerplate/app/modules/login/binding.dart';
import 'package:mvp_boilerplate/app/modules/login/view.dart';
import 'package:mvp_boilerplate/app/modules/onboarding/binding.dart';
import 'package:mvp_boilerplate/app/modules/onboarding/view.dart';
import 'package:mvp_boilerplate/app/modules/profile/binding.dart';
import 'package:mvp_boilerplate/app/modules/profile/view.dart';
import 'package:mvp_boilerplate/app/modules/register/binding.dart';
import 'package:mvp_boilerplate/app/modules/register/view.dart';
import 'package:mvp_boilerplate/app/modules/settings/binding.dart';
import 'package:mvp_boilerplate/app/modules/settings/view.dart';
import 'package:mvp_boilerplate/app/modules/splash/binding.dart';
import 'package:mvp_boilerplate/app/modules/splash/view.dart';


import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}