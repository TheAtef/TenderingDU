import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fNameCtrl = TextEditingController();
  final lNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final birthdateCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final crnCtrl = TextEditingController();

  var selectedSex = RxnString();
  var selectedActivity = RxnString();

  final sexOptions = ['Male', 'Female'];
  final activities = [
    'Construction',
    'IT',
    'Healthcare',
  ]; // Matched existing categories

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  void setSex(String? val) => selectedSex.value = val;
  void setActivity(String? val) => selectedActivity.value = val;

  void register() async {
    // If the view handles step-by-step validation, we only ensure final step here
    // but the formKey check should still be there for safety if accessed otherwise.
    if (birthdateCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty) {
      if (selectedSex.value == null) {
        Get.snackbar(
          'Error',
          'Please select your sex',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      if (selectedActivity.value == null) {
        Get.snackbar(
          'Error',
          'Please select a business activity',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;
      // Mock API Registration
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      isSuccess.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));

      Get.snackbar('Success', 'Account created successfully!');
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }

  void navigateToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    fNameCtrl.dispose();
    lNameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    birthdateCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    companyCtrl.dispose();
    crnCtrl.dispose();
    super.onClose();
  }
}
