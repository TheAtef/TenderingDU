import 'package:get/get.dart';
import 'package:tendering_du/app/modules/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put ensures the SplashController is initialized
    // immediately when the SplashView is called.
    Get.put<SplashController>(SplashController());
  }
}
