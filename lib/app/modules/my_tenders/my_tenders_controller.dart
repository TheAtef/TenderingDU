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
