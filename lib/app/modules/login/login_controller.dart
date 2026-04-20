import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
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
