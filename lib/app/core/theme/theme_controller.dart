import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/storage/local_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  // Reactive state
  final _isDarkMode = true.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode.value = StorageService.getDarkMode();
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    await StorageService.setDarkMode(_isDarkMode.value);
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    await StorageService.setDarkMode(value);
  }

  Color get backgroundColor =>
      isDarkMode ? AppColors.darkNavy : AppColors.lightBackground;

  Color get cardColor =>
      isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white;

  Color get textPrimary =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get textSecondary =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get borderColor => isDarkMode
      ? Colors.white.withOpacity(0.1)
      : Colors.black.withOpacity(0.08);

  List<Color> get gradientColors =>
      isDarkMode ? AppColors.darkGradient : AppColors.lightGradient;

  Color get iconBgColor => isDarkMode
      ? Colors.white.withOpacity(0.1)
      : AppColors.actionBlue.withOpacity(0.1);

  Color get glowBlue => isDarkMode
      ? AppColors.actionBlue.withOpacity(0.2)
      : AppColors.actionBlue.withOpacity(0.1);

  Color get glowPurple => isDarkMode
      ? Colors.purple.withOpacity(0.1)
      : Colors.purple.withOpacity(0.05);
}
