import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/modules/receivedBids/received_bids_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

class BidDetailsController extends GetxController {
  var bid = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      bid.value = Get.arguments;
    }
  }

  void viewAttachment(String url, String name) {
    if (url.isEmpty) return;
    Get.toNamed(Routes.PDF_VIEWER, arguments: {'url': url, 'title': name});
  }

  void handleBidAction(int id, String status) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await Future.delayed(const Duration(seconds: 1));

      Get.back();
      Get.back();

      if (Get.isRegistered<ReceivedBidsController>()) {
        Get.find<ReceivedBidsController>().bidsList.removeWhere(
          (item) => item['id'] == id,
        );
      }

      Get.snackbar(
        "Success",
        "Bid ${status}ed successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: status == "accept" ? Colors.green : Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to update bid status");
    }
  }
}
