import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_model.dart';

class TenderResultsController extends GetxController {
  final ApiService _apiService = ApiService();
  var isLoading = true.obs;
  var tenders = <TenderDetailsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTenders();
  }

  Future<void> fetchTenders() async {
    try {
      isLoading.value = true;
      final rawData = await _apiService.getTenderResults();

      final parsedTenders = rawData
          .map((json) {
            try {
              return TenderDetailsModel.fromJson(json);
            } catch (e) {
              print("Error parsing tender result: $e");
              return null;
            }
          })
          .whereType<TenderDetailsModel>()
          .toList();

      tenders.assignAll(parsedTenders);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tender results");
    } finally {
      isLoading.value = false;
    }
  }
}
