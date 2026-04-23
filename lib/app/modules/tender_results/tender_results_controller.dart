import 'package:get/get.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_model.dart';

class TenderResultsController extends GetxController {
  var isLoading = true.obs;
  // Use TenderDetailsModel instead of the old TenderModel
  var tenders = <TenderDetailsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTenders();
  }

  Future<void> fetchTenders() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      tenders.assignAll([
        TenderDetailsModel(
          id: 1,
          title: "وزارة الدفاع التكتيكية",
          category: "Construction",
          description: "",
          deadline: "",
          status: "",
          estimatedBudget: "",
          requirements: [],
          pdfUrl: "",
          postedDate: "",
        ),
        TenderDetailsModel(
          id: 2,
          title: "مشروع الرصيف الخارق",
          category: "Infrastructure",
          description: "",
          deadline: "",
          status: "",
          estimatedBudget: "",
          requirements: [],
          pdfUrl: "",
          postedDate: "",
        ),
      ]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tenders");
    } finally {
      isLoading.value = false;
    }
  }
}
