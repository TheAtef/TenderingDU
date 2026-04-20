import 'package:get/get.dart';
import 'tender_results_controller.dart';

class TenderResultsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TenderResultsController());
  }
}
