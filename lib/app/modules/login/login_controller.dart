import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import '../../core/services/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final formKey = GlobalKey<FormState>();
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await _apiService.login(
        email: identifierCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );

      if (result['success']) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Login Failed',
          'Incorrect email/phone or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
