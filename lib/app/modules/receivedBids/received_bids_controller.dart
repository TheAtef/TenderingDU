import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

class ReceivedBidsController extends GetxController {
  final ApiService _apiService = ApiService();

  var bidsList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBids();
  }

  Future<void> fetchBids() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(milliseconds: 500));
      bidsList.assignAll([
        {
          "id": 1,
          "bidder": "Global Construction Ltd",
          "amount": "240,000",
          "date": "2 hours ago",
          "duration": "6 Months",
          "proposal":
              "Comprehensive construction plan with high-durability materials.",
          "attachments": [
            {
              "name": "Technical_Proposal.pdf",
              "url": "https://example.com/file1.pdf",
            },
          ],
        },
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void viewAttachment(String url, String name) {
    if (url.isEmpty) {
      Get.snackbar("Error", "No document URL available");
      return;
    }
    Get.toNamed(Routes.PDF_VIEWER, arguments: {'url': url, 'title': name});
  }

  void goToDetails(Map<String, dynamic> bid) {
    Get.toNamed(Routes.BID_DETAILS, arguments: bid);
  }
}
