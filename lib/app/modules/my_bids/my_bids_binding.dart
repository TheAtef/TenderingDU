import 'package:get/get.dart';
import 'package:tendering_du/app/modules/my_bids/my_bids_controller.dart';

class BidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BidsController>(() => BidsController());
  }
}
