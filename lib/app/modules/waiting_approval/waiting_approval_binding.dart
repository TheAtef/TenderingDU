import 'package:get/get.dart';
import 'waiting_approval_controller.dart';

class WaitingApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingApprovalController>(() => WaitingApprovalController());
  }
}
