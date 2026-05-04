import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
