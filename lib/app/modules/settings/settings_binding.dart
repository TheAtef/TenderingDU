import 'package:get/get.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }

    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
