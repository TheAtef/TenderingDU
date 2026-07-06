import 'package:get/get.dart';

import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/my_tenders/my_tender_model.dart';

import 'my_tender_details_model.dart';

class MyTenderDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final MyTenderModel basicTender = Get.arguments as MyTenderModel;

  final isLoading = true.obs;
  final isError = false.obs;

  late MyTenderDetailsModel tenderDetails;

  @override
  void onInit() {
    super.onInit();
    fetchTenderDetails();
  }

  Future<void> fetchTenderDetails() async {
    isLoading.value = true;
    isError.value = false;
    try {
      final data = await _apiService.getTenderDetails(basicTender.id);
      tenderDetails = MyTenderDetailsModel.fromJson(data);
    } catch (e) {
      isError.value = true;
      print('Fetch my tender details error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
