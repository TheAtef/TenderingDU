import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tendering_du/app/core/services/api_service.dart'; // Ensure this path is correct
import 'package:tendering_du/app/modules/home/home_model.dart';
import 'tender_details_model.dart';

class TenderDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final Tender basicTender = Get.arguments;

  final isLoading = true.obs;
  final isError = false.obs;
  final isSubmitting = false.obs;
  final isFavourite = false.obs;

  late TenderDetailsModel tenderDetails;

  @override
  void onInit() {
    super.onInit();
    isFavourite.value = basicTender.isFavourite;
    fetchTenderDetails();
  }

  Future<void> fetchTenderDetails() async {
    isLoading.value = true;
    isError.value = false;

    try {
      final data = await _apiService.getTenderDetails(basicTender.id);

      tenderDetails = TenderDetailsModel.fromJson(data);

      isFavourite.value = tenderDetails.isFavourite;

      isLoading.value = false;
    } catch (e) {
      print("Error fetching tender details: $e");
      isLoading.value = false;
      isError.value = true;
    }
  }

  void toggleFavourite() async {
    isFavourite.value = !isFavourite.value;

    try {
      bool success = await _apiService.toggleSaveTender(
        basicTender.id,
        isFavourite.value,
      );

      if (success) {
        basicTender.isFavourite = isFavourite.value;
      } else {
        throw Exception("Server returned false");
      }
    } catch (e) {
      isFavourite.value = !isFavourite.value;
      Get.snackbar(
        'Error',
        'Could not update saved status. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitBid() async {
    isSubmitting.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Your bid submitted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Submission failed. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
