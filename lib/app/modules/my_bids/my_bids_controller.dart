import 'package:get/get.dart';
import 'package:tendering_du/app/modules/my_bids/my_bids_model.dart';

class BidsController extends GetxController {
  var appliedList = <Bid>[].obs;
  var historyList = <Bid>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchFromServer().then((bids) {
      appliedList.assignAll(bids.$1);
      historyList.assignAll(bids.$2);
      isLoading.value = false;
    });
  }

  Future<(List<Bid>, List<Bid>)> _fetchFromServer() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final categories = ['construction'.tr, 'it'.tr, 'healthcare'.tr];
    final statuses = ['history'.tr, 'applied'.tr];

    List<Bid> mockDb = List.generate(20, (index) {
      return Bid(
        id: index,
        title: 'Tender Project Title ${index + 1}',
        description: 'Detailed description for tender ${index + 1}',
        deadline: '${10 + (index % 15)} days left',
        category: categories[index % categories.length],
        status: statuses[index % statuses.length],
        bidDetails: 'Bid details for tender ${index + 1}',
        isWinningBid: statuses[index % statuses.length] == 'history'
            ? index % 5 == 0
            : false,
      );
    });

    var filtered = mockDb;
    var appliedList = filtered
        .where((t) => t.status.toLowerCase() == 'applied'.tr)
        .toList();
    var historyList = filtered
        .where((t) => t.status.toLowerCase() == 'history'.tr)
        .toList();

    return (appliedList, historyList);
  }
}
