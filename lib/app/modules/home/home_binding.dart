import 'package:get/get.dart';
import 'home_controller.dart';
import '../saved/saved_controller.dart';
import '../profile/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());

    Get.lazyPut<SavedController>(() => SavedController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
