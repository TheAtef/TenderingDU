import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
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
    } catch (e) {
      isError.value = true;
      print("Fetch Error: $e");
    } finally {
      isLoading.value = false;
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

  void submitBid() {
    if (isLoading.value || isError.value) {
      Get.snackbar(
        'Wait',
        'Please wait for tender details to load.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed('/submit-bid', arguments: tenderDetails);
  }
}
