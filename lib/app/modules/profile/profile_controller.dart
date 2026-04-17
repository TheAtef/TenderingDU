import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/modules/profile/profile_model.dart';

class ProfileController extends GetxController {
  final profile = Rxn<ProfileModel>();
  final ScrollController scrollCtrl = ScrollController();
  var isLoading = true.obs;

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
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+1234567890',
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
