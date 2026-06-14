import 'package:get/get.dart';
import 'package:tendering_du/app/modules/otp/otp_conroller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
