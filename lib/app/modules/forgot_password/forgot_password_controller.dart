import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifierCtrl = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    identifierCtrl.dispose();
    super.onClose();
  }

  void resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      "Success",
      "Password reset link has been sent to your email/phone if it exists in our system.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    // Optionally go back to login automatically
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      Get.back();
    });
  }
}
