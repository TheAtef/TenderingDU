import 'dart:ui';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/modules/settings/change_password_binding.dart';
import 'package:tendering_du/app/modules/settings/change_password_view.dart';

class SettingsController extends GetxController {
  ThemeController get themeController => Get.find<ThemeController>();
  final pushNotifications = true.obs;
  final emailNotifications = false.obs;
  final deadlineReminders = true.obs;
  final selectedLanguage = "العربية".obs;
  final languages = ["English", "العربية"];
  bool get isDarkMode => themeController.isDarkMode;
  Future<void> toggleTheme(bool value) async {
    await themeController.setDarkMode(value);
  }

  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailNotifications(bool value) => emailNotifications.value = value;
  void toggleDeadlineReminders(bool value) => deadlineReminders.value = value;
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    if (lang == "English") {
      Get.updateLocale(Locale('en', 'US'));
    } else if (lang == "العربية") {
      Get.updateLocale(Locale('ar', 'SY'));
    }
  }

  void changePassword() {
    // We use Get.to with binding to keep the architecture clean
    Get.to(() => const ChangePasswordView(), binding: ChangePasswordBinding());
  }
}
