import 'package:get/get.dart';
import 'package:tendering_du/app/modules/my_bids/my_bids_binding.dart';
import 'package:tendering_du/app/modules/my_bids/my_bids_view.dart';
import 'package:tendering_du/app/modules/settings/settings_binding.dart';
import 'package:tendering_du/app/modules/settings/settings_view.dart';
import 'package:tendering_du/app/modules/splash/splash_view.dart';
import 'package:tendering_du/app/modules/splash/splash_binding.dart';
import 'package:tendering_du/app/modules/submit_bid/submit_bid_view.dart';
import 'package:tendering_du/app/modules/submit_bid/sumbit_bid_binding.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
// Import your dashboard or next view/binding here
import 'package:tendering_du/app/modules/home/home_view.dart';
import 'package:tendering_du/app/modules/home/home_binding.dart';
import 'package:tendering_du/app/modules/notifications/notifications_view.dart';
import 'package:tendering_du/app/modules/notifications/notifications_binding.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_view.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_binding.dart';
import 'package:tendering_du/app/modules/login/login_view.dart';
import 'package:tendering_du/app/modules/login/login_binding.dart';
import 'package:tendering_du/app/modules/register/register_view.dart';
import 'package:tendering_du/app/modules/register/register_binding.dart';
import 'package:tendering_du/app/modules/onboarding_page/onboarding_view.dart';
import 'package:tendering_du/app/modules/onboarding_page/onboarding_binding.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
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
    GetPage(
      name: Routes.MYBIDS,
      page: () => const BidsView(),
      binding: BidsBinding(),
    ),
    GetPage(
      name: '/submit-bid',
      page: () => const SubmitBidView(),
      binding: SubmitBidBinding(),
    ),
  ];
}
