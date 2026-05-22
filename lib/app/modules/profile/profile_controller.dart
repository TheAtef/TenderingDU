import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/profile/profile_model.dart';

class ProfileController extends GetxController {
  final profile = Rxn<ProfileModel>();
  final ScrollController scrollCtrl = ScrollController();
  var isLoading = true.obs;

  // Edit Form Key
  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  // Edit Text Controllers
  final editFirstNameCtrl = TextEditingController();
  final editLastNameCtrl = TextEditingController();
  final editEmailCtrl = TextEditingController();
  final editPhoneCtrl = TextEditingController();
  final editBirthdateCtrl = TextEditingController();
  final editSexCtrl = TextEditingController();
  final editPasswordCtrl = TextEditingController();

  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  void populateEditFields() {
    if (Get.isBottomSheetOpen ?? false) return; // Prevent double sheets
    editFormKey = GlobalKey<FormState>(); // Renew the key on every open

    final cur = profile.value;
    if (cur != null) {
      editFirstNameCtrl.text = cur.firstName;
      editLastNameCtrl.text = cur.lastName;
      editEmailCtrl.text = cur.email;
      editPhoneCtrl.text = cur.phone;
      editBirthdateCtrl.text = cur.birthdate;
      editSexCtrl.text = cur.sex.capitalizeFirst!;
      editPasswordCtrl.clear();
      isPasswordHidden.value = true;
    }
  }

  Future<void> saveProfileChanges() async {
    final cur = profile.value;
    if (cur == null) return;

    // Fixed logical check: Change '||' to '&&' so that updating any single field is allowed.
    if (editEmailCtrl.text.trim() == cur.email &&
        editPhoneCtrl.text.trim() == cur.phone &&
        editBirthdateCtrl.text.trim() == cur.birthdate &&
        editSexCtrl.text.trim().toLowerCase() == cur.sex.toLowerCase() &&
        editFirstNameCtrl.text.trim() == cur.firstName &&
        editLastNameCtrl.text.trim() == cur.lastName) {
      Get.back();
      Get.snackbar(
        'Huh?',
        'No changes detected to save.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (editFormKey.currentState?.validate() ?? false) {
      isLoading.value = true; // Turn on loader
      final ApiService _apiService = ApiService();

      try {
        // 1. Verify the password first
        final bool isPasswordCorrect = await _apiService.checkPassword(
          editPasswordCtrl.text.trim(),
        );

        if (!isPasswordCorrect) {
          Get.snackbar(
            'Verification Failed',
            'The password you entered is incorrect.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }

        // 2. If password is correct, apply profile updates
        final bool success = await _apiService.editProfile(
          email: editEmailCtrl.text.trim(),
          phone: editPhoneCtrl.text.trim(),
          gender: editSexCtrl.text.trim().toLowerCase(),
          birthDate: editBirthdateCtrl.text.trim(),
          firstName: editFirstNameCtrl.text.trim(),
          lastName: editLastNameCtrl.text.trim(),
        );

        if (success) {
          await fetchProfileFromApi();
          Get.back();
          Get.snackbar(
            'Success',
            'Profile updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save changes. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileFromApi();
  }

  @override
  void onClose() {
    scrollCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchProfileFromApi() async {
    isLoading.value = true;
    final ApiService _apiService = ApiService();

    try {
      // await Future.delayed(const Duration(milliseconds: 1500));
      final getProfileResult = await _apiService.getProfile();
      print(getProfileResult);
      profile.value = ProfileModel.fromJson(getProfileResult);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile from server.');
    } finally {
      isLoading.value = false;
    }
  }
}
