import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import '../my_bids/bid_model.dart';

class ReceivedBidsController extends GetxController {
  final ApiService _apiService = ApiService();

  var bidsList = <BidModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBids();
  }

  Future<void> fetchBids() async {
    try {
      isLoading.value = true;
      final rawData = await _apiService.getReceivedBids();

      final parsedBids = rawData
          .map((json) {
            try {
              return BidModel.fromJson(json);
            } catch (e) {
              print("Error parsing single bid: $e");
              return null;
            }
          })
          .whereType<BidModel>()
          .toList();

      bidsList.assignAll(parsedBids);
    } catch (e) {
      print("Error fetching bids: $e");
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

  void goToDetails(BidModel bid) {
    Get.toNamed(Routes.BID_DETAILS, arguments: bid);
  }
}
