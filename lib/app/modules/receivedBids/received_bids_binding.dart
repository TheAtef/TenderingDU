import 'package:get/get.dart';
import 'received_bids_controller.dart';

class ReceivedBidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceivedBidsController>(() => ReceivedBidsController());
  }
}
