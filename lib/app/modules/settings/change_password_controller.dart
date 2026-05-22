import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/api_service.dart';

class ChangePasswordController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final obscureMap = {
    "Current Password": true,
    "New Password": true,
    "Confirm New Password": true,
  }.obs;

  void toggleObscure(String key) {
    obscureMap[key] = !obscureMap[key]!;
  }

  Future<void> updatePassword() async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _apiService.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (result['success']) {
        Get.back(); // Return to previous screen
        Get.snackbar(
          "Success",
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Failed",
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
