import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tendering_du/app/modules/home/home_controller.dart';
import 'tender_details_model.dart';

class TenderDetailsController extends GetxController {
  final Tender basicTender = Get.arguments;

  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var isFavourite = false.obs;

  var tenderDetails = Rxn<TenderDetailsModel>();

  @override
  void onInit() {
    super.onInit();
    isFavourite.value = basicTender.isFavourite;
    fetchTenderDetailsFromApi();
  }

  Future<void> fetchTenderDetailsFromApi() async {
    isLoading.value = true;

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
        'is_favourite': basicTender.isFavourite,
      };

      tenderDetails.value = TenderDetailsModel.fromJson(mockApiResponse);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load details from server.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavourite() async {
    isFavourite.value = !isFavourite.value;

    // await http.post('.../api/tenders/${basicTender.id}/favorite');

    basicTender.isFavourite = isFavourite.value;
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().tenderList.refresh();
    }
  }

  Future<void> submitBid() async {
    isSubmitting.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isSubmitting.value = false;

    Get.snackbar(
      'Success',
      'Your bid has been submitted successfully.',
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );

    Future.delayed(const Duration(seconds: 2), () => Get.back());
  }
}
