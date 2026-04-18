import 'package:get/get.dart';
import 'submit_bid_controller.dart';

class SubmitBidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmitBidController>(() => SubmitBidController());
  }
}
