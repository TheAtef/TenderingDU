import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/services/api_service.dart';

class RegisterController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

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

  final sexOptions = ['male'.tr, 'female'.tr];

  final activities = ['construction'.tr, 'it'.tr, 'healthcare'.tr];

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  void setSex(String? val) => selectedSex.value = val;
  void setActivity(String? val) => selectedActivity.value = val;

  Future<void> register() async {
    if (selectedSex.value == null) {
      Get.snackbar('error'.tr, 'select_sex'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final username =
          "${fNameCtrl.text.trim().toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}";

      final result = await _apiService.register(
        email: emailCtrl.text.trim(),
        phone: mobileCtrl.text.trim(),
        gender: selectedSex.value!,
        crNumber: crnCtrl.text.trim(),
        birthDate: birthdateCtrl.text.trim(),
        firstName: fNameCtrl.text.trim(),
        lastName: lNameCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
        username: username,
      );

      isLoading.value = false;

      if (result['success']) {
        isSuccess.value = true;

        await Future.delayed(const Duration(milliseconds: 1200));

        Get.snackbar(
          'Success',
          'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(Routes.ONBOARDING);
      } else {
        Get.snackbar(
          'Registration Failed',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;

      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
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
