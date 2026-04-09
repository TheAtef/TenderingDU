import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // 1. Wait for 3 seconds (adjust time as needed)
    await Future.delayed(const Duration(seconds: 3));

    // If you are using named routes:
    // Get.offNamed('/homepage');
  }
}
