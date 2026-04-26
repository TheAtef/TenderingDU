import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      editSexCtrl.text = cur.sex;
      editPasswordCtrl.clear();
      isPasswordHidden.value = true;
    }
  }

  void saveProfileChanges() {
    if (editFormKey.currentState?.validate() ?? false) {
      final cur = profile.value;
      if (cur != null) {
        profile.value = ProfileModel(
          firstName: editFirstNameCtrl.text,
          lastName: editLastNameCtrl.text,
          email: editEmailCtrl.text,
          phone: editPhoneCtrl.text,
          birthdate: editBirthdateCtrl.text,
          sex: editSexCtrl.text,
          company: cur.company, // Unchanged
          CRN: cur.CRN, // Unchanged
          isVerified: cur.isVerified,
        );
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

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      final mockApiResponse = {
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john.doe@example.com',
        'phone': '0933123456',
        'birthdate': '1990-01-01',
        'sex': 'Male',
        'company': 'Example Inc.',
        'commercial_register_number': '123456789',
        'is_verified': true,
      };

      profile.value = ProfileModel.fromJson(mockApiResponse);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile from server.');
    } finally {
      isLoading.value = false;
    }
  }
}
