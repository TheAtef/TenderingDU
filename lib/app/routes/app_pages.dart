import 'package:get/get.dart';
import 'package:tendering_du/app/modules/splash/splash_view.dart';
import 'package:tendering_du/app/modules/splash/splash_binding.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
// Import your dashboard or next view/binding here
import 'package:tendering_du/app/modules/home/home_view.dart';
import 'package:tendering_du/app/modules/home/home_binding.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: Routes.NOTIFICATIONS,
    //   page: () => const NoicationsView(),
    //   binding: NotificationsBinding(),
    // ),
  ];
}
