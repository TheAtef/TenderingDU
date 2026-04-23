import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tendering_du/app/modules/home/home_controller.dart';
import 'package:tendering_du/app/modules/home/home_model.dart';
import 'tender_details_model.dart';

class TenderDetailsController extends GetxController {
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
      await Future.delayed(const Duration(milliseconds: 1500));

      final mockApiResponse = {
        'id': basicTender.id,
        'title': basicTender.title,
        'description':
            'This is a highly detailed description coming from the API. ' * 4,
        'deadline': basicTender.deadline,
        'category': basicTender.category,
        'status': basicTender.status,
        'estimated_budget': '\$2,500,000',
        'requirements': [
          'Valid Trade License',
          'Tax Clearance Certificate',
          'Company Profile & Portfolio',
          'Financial Statements (Last 2 Years)',
        ],
        'pdf_url':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'postedDate': '',
        'is_favourite': basicTender.isFavourite,
      };

      tenderDetails = TenderDetailsModel.fromJson(mockApiResponse);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      Get.snackbar('Error', 'Failed to load details');
    }
  }

  void toggleFavourite() {
    isFavourite.value = !isFavourite.value;
    basicTender.isFavourite = isFavourite.value;
  }

  Future<void> submitBid() async {
    isSubmitting.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isSubmitting.value = false;

    Get.snackbar(
      'Success',
      'Your bid submitted successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }
}
