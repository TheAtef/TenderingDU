import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'billing_model.dart';

class BillingController extends GetxController {
  final ApiService _apiService = ApiService();

  var invoices = <BillingInvoice>[].obs;
  var isLoading = false.obs;
  var activeTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    isLoading.value = true;
    try {
      final List<dynamic> response = await _apiService.getMyTenders();

      final allInvoices = response
          .map((json) => BillingInvoice.fromJson(json))
          .where((invoice) => invoice.hasActiveInvoice)
          .toList();

      invoices.assignAll(allInvoices);
    } catch (e) {
      Get.snackbar("Error", "Could not retrieve your invoices.");
    } finally {
      isLoading.value = false;
    }
  }

  List<BillingInvoice> get filteredInvoices {
    if (activeTab.value == 0) {
      return invoices.where((i) => i.paymentStatus == 'Pending').toList();
    } else {
      return invoices.where((i) => i.paymentStatus == 'Paid').toList();
    }
  }
}
