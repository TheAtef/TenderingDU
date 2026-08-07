import 'package:get/get.dart';

import 'my_tender_details_controller.dart';

class MyTenderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTenderDetailsController>(() => MyTenderDetailsController());
  }
}
