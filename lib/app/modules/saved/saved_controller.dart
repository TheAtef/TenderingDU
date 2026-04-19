import 'package:get/get.dart';
import 'package:tendering_du/app/modules/home/home_controller.dart';

class SavedController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  var savedList = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedTenders();
    refreshData();
  }

  void fetchSavedTenders() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    savedList.value = homeController.tenderList
        .where((t) => t.isFavourite)
        .toList();
    isLoading.value = false;
  }

  void refreshData() {
    isLoading.value = true;
    savedList.value = homeController.tenderList
        .where((t) => t.isFavourite)
        .toList();
    isLoading.value = false;
  }

  void removeFromSaved(dynamic tender) {
    homeController.toggleFavourite(tender);
    refreshData();
  }
}
