import 'package:get/get.dart';

class TenderModel {
  final String title;
  final String category;
  TenderModel({required this.title, required this.category});
}

class TenderResultsController extends GetxController {
  var isLoading = true.obs;
  var tenders = <TenderModel>[].obs;

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
        TenderModel(title: "وزارة الدفاع التكتيكية", category: "Construction"),
        TenderModel(title: "مشروع الرصيف الخارق", category: "Infrastructure"),
      ]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load tenders");
    } finally {
      isLoading.value = false;
    }
  }
}
