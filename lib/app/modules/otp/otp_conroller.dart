import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import '../../core/services/api_service.dart';

class OtpController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final formKey = GlobalKey<FormState>();
  final otpCtrl = TextEditingController();
  var isLoading = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      final email = Get.arguments['email'];
      if (email != null) {
        await ctrlSendOtp();
        isLoading.value = false;
      }
    }
  }

  Future<void> ctrlSendOtp() async {
    isLoading.value = true;
    try {
      final result = await _apiService.sendOtp(email: Get.arguments['email']);
      if (!result['success']) {
        Get.snackbar(
          'Error',
          result['error'] ?? 'Failed to send OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final result = await _apiService.verifyOtp(
        email: Get.arguments['email'],
        otp: otpCtrl.text.trim(),
      );

      if (result['success']) {
        String? previousPage = Get.previousRoute;
        if (previousPage == Routes.SETTINGS) {
          Get.offNamed(Routes.CHANGE_PASSWORD);
        } else {
          Get.offAllNamed(Routes.ONBOARDING);
        }
      } else {
        Get.snackbar(
          'OTP Verification Failed',
          result['error'] ?? 'Incorrect OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpCtrl.dispose();
    super.onClose();
  }
}
