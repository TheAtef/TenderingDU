import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';

import 'my_tender_model.dart';

class MyTendersController extends GetxController {
  final ApiService _apiService = ApiService();
  final tenders = <MyTenderModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyTenders();
  }

  Future<void> fetchMyTenders() async {
    isLoading.value = true;
    try {
      final rawData = await _apiService.getMyTenders();
      final parsedTenders = rawData
          .map((json) {
            try {
              return MyTenderModel.fromJson(json as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing my tenders: $e');
              return null;
            }
          })
          .whereType<MyTenderModel>()
          .toList();

      tenders.assignAll(parsedTenders);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTender(int tenderId) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final result = await _apiService.deleteTender(tenderId);
    Get.back();
    if (result['success'] == true) {
      tenders.removeWhere((tender) => tender.id == tenderId);
      Get.snackbar(
        'Success',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'Action Failed',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  List<MyTenderModel> get filteredTenders {
    if (selectedFilter.value == 'all') {
      return tenders;
    }

    return tenders
        .where((tender) => tender.status.toLowerCase() == selectedFilter.value)
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  int countByStatus(String status) {
    return tenders
        .where((tender) => tender.status.toLowerCase() == status.toLowerCase())
        .length;
  }
}
