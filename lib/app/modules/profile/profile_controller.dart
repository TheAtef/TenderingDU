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
    final cur = profile.value!;
    if (editEmailCtrl.text.trim() == cur.email ||
        editPhoneCtrl.text.trim() == cur.phone ||
        editBirthdateCtrl.text.trim() == cur.birthdate ||
        editSexCtrl.text.trim() == cur.sex ||
        editFirstNameCtrl.text.trim() == cur.firstName ||
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
      final ApiService _apiService = ApiService();
      _apiService.editProfile(
        email: editEmailCtrl.text,
        phone: editPhoneCtrl.text,
        gender: editSexCtrl.text.toLowerCase(),
        birthDate: editBirthdateCtrl.text,
        firstName: editFirstNameCtrl.text,
        lastName: editLastNameCtrl.text,
      );
      await Future.delayed(const Duration(seconds: 1));
      onInit();
      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
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
