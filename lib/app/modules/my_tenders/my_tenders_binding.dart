import 'package:get/get.dart';

import 'my_tenders_controller.dart';

class MyTendersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTendersController>(() => MyTendersController());
  }
}
