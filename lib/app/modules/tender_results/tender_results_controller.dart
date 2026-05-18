import 'package:get/get.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_model.dart';

class TenderResultsController extends GetxController {
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
      await Future.delayed(const Duration(seconds: 1));

      tenders.assignAll([
        TenderDetailsModel(
          id: 1,
          title: "مشروع خالص ",
          category: "Construction",
          description: "Description here",
          deadline: "2024-12-01",
          status: "open",
          currency: "USD",
          budgetMin: "1000",
          budgetMax: "5000",
          startDate: "2024-10-01",
          location: "Muscat",
          requirements: ["Requirement 1"],
          pdfUrl: "https://example.com/doc1.pdf",
        ),
        TenderDetailsModel(
          id: 2,
          title: "مشروع الرصيف الخارق",
          category: "Infrastructure",
          description: "Description here",
          deadline: "2024-11-15",
          status: "closed",
          currency: "OMR",
          budgetMin: "20000",
          budgetMax: "50000",
          startDate: "2024-09-01",
          location: "Salalah",
          requirements: ["Requirement A"],
          pdfUrl: "https://example.com/doc2.pdf",
        ),
      ]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tenders");
    } finally {
      isLoading.value = false;
    }
  }
}
