import 'package:get/get.dart';
import 'package:tendering_du/app/modules/bidsDetails/bidDetails_controller.dart';

class BidDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BidDetailsController>(() => BidDetailsController());
  }
}
