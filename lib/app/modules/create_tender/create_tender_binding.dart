import 'package:get/get.dart';
import 'create_tender_controller.dart';

class CreateTenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTenderController>(() => CreateTenderController());
  }
}
