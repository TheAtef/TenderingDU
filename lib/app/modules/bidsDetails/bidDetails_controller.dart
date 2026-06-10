import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/my_bids/bid_model.dart';
import 'package:tendering_du/app/modules/receivedBids/received_bids_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';

class BidDetailsController extends GetxController {
  final ApiService _apiService = ApiService();
  final storage = GetStorage();

  late BidModel bid;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      bid = Get.arguments as BidModel;
      isLoading.value = false;
    }
  }

  bool get canPerformActions {
    final loggedInUserId = storage.read('user_id')?.toString();
    if (bid.userName == storage.read('username') ||
        bid.statusName.toLowerCase() != 'pending') {
      return false;
    }
    return true;
  }

  void viewAttachment(String url, String name) {
    if (url.isEmpty) return;
    Get.toNamed(Routes.PDF_VIEWER, arguments: {'url': url, 'title': name});
  }

  void handleBidAction(int bidId, String status) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      bool success = false;
      if (status == "accept") {
        success = await _apiService.acceptBid(bidId);
      } else {
        success = await _apiService.rejectBid(bidId);
      }

      Get.back();

      if (success) {
        Get.back();

        if (Get.isRegistered<ReceivedBidsController>()) {
          Get.find<ReceivedBidsController>().bidsList.removeWhere(
            (item) => item.id == bidId,
          );
        }

        Get.snackbar(
          "Success",
          "Bid ${status}ed successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: status == "accept" ? Colors.green : Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Server status update rejected");
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to update bid status. Please check your permissions.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
