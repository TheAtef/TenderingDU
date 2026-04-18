import 'package:get/get.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';

class SettingsController extends GetxController {
  ThemeController get themeController => Get.find<ThemeController>();
  final pushNotifications = true.obs;
  final emailNotifications = false.obs;
  final deadlineReminders = true.obs;
  final selectedLanguage = "English".obs;
  final languages = ["English", "العربية"];
  bool get isDarkMode => themeController.isDarkMode;
  Future<void> toggleTheme(bool value) async {
    await themeController.setDarkMode(value);
  }

  void togglePushNotifications(bool value) => pushNotifications.value = value;
  void toggleEmailNotifications(bool value) => emailNotifications.value = value;
  void toggleDeadlineReminders(bool value) => deadlineReminders.value = value;
  void changeLanguage(String lang) => selectedLanguage.value = lang;
  void changePassword() {
    Get.snackbar("Change Password", " كلنا منعرف اسرارك");
  }
}
