import 'package:get/get.dart';
import 'tender_details_controller.dart';

class TenderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderDetailsController>(() => TenderDetailsController());
  }
}
