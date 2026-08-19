import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/services/notification_service.dart';

class SettingsController extends GetxController {
  ThemeController get themeController => Get.find<ThemeController>();
  final storage = GetStorage();

  late final RxBool pushNotifications;

  final emailNotifications = false.obs;
  final deadlineReminders = true.obs;
  final selectedLanguage = "English".obs;
  final languages = ["English", "العربية"];

  bool get isDarkMode => themeController.isDarkMode;

  @override
  void onInit() {
    super.onInit();
    pushNotifications = (storage.read('push_notifications') ?? true).obs;
  }

  Future<void> toggleTheme(bool value) async {
    await themeController.setDarkMode(value);
  }

  Future<void> togglePushNotifications(bool value) async {
    pushNotifications.value = value;
    storage.write('push_notifications', value);

    if (value) {
      await NotificationService().initialize();
    } else {
      await NotificationService().disableNotifications();
    }
  }

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

  void otpPage() {
    Get.toNamed(Routes.OTP_PAGE, arguments: {'email': storage.read('email')});
  }
}
