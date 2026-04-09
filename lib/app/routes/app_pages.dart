import 'package:get/get.dart';
import 'package:tendering_du/app/modules/splash/splash_view.dart';
import 'package:tendering_du/app/modules/splash/splash_binding.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
// Import your dashboard or next view/binding here

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
