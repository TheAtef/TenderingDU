import 'package:get/get.dart';
import 'package:tendering_du/app/modules/settings/settings_binding.dart';
import 'package:tendering_du/app/modules/settings/settings_view.dart';
import 'package:tendering_du/app/modules/splash/splash_view.dart';
import 'package:tendering_du/app/modules/splash/splash_binding.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
// Import your dashboard or next view/binding here
import 'package:tendering_du/app/modules/home/home_view.dart';
import 'package:tendering_du/app/modules/home/home_binding.dart';
import 'package:tendering_du/app/modules/notifications/notifications_view.dart';
import 'package:tendering_du/app/modules/notifications/notifications_binding.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_view.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_binding.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

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
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.TENDER_DETAILS,
      page: () => const TenderDetailsView(),
      binding: TenderDetailsBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
