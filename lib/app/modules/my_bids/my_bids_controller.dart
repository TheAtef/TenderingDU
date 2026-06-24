import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/my_bids/bid_model.dart';

class BidsController extends GetxController {
  final ApiService _apiService = ApiService();

  var appliedList = <BidModel>[].obs;
  var historyList = <BidModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyBids();
  }

  Future<void> fetchMyBids() async {
    try {
      isLoading.value = true;
      final rawData = await _apiService.getMyBids();

      final parsedBids = rawData
          .map((json) {
            try {
              return BidModel.fromJson(json);
            } catch (e) {
              print("Error parsing my bids: $e");
              return null;
            }
          })
          .whereType<BidModel>()
          .toList();

      final applied = parsedBids
          .where((b) => b.statusName.toLowerCase() == 'pending')
          .toList();

      final history = parsedBids
          .where(
            (b) =>
                b.statusName.toLowerCase() == 'awarded' ||
                b.statusName.toLowerCase() == 'rejected' ||
                b.statusName.toLowerCase() == 'closed',
          )
          .toList();

      appliedList.assignAll(applied);
      historyList.assignAll(history);
    } catch (e) {
      print("Error loading my bids: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
