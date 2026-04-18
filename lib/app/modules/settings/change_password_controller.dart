import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
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
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.back();
    Get.snackbar("Success", "Password updated successfully");
  }
}
