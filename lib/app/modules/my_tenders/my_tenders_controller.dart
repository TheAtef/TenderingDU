import 'package:get/get.dart';

import 'my_tender_model.dart';

class MyTendersController extends GetxController {
  final tenders = <MyTenderModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyTenders();
  }

  Future<void> fetchMyTenders() async {
    isLoading.value = true;
    try {
      // Future API hook:
      // final rawData = await _apiService.getMyTenders();
      // tenders.assignAll(rawData.map((json) => MyTenderModel.fromJson(json)));

      await Future<void>.delayed(const Duration(milliseconds: 250));
      tenders.assignAll(const [
        MyTenderModel(
          id: 1,
          title: 'Campus Wi-Fi Expansion',
          category: 'IT Infrastructure',
          status: 'Open',
          budget: '\$240,000',
          deadline: '12 Jul 2026',
          bidsCount: 7,
          description:
              'Expansion of the university wireless network across lecture halls and administrative buildings.',
          isPinned: true,
        ),
        MyTenderModel(
          id: 2,
          title: 'Student Portal Redesign',
          category: 'Software Development',
          status: 'Closed',
          budget: '\$87,500',
          deadline: '24 Jul 2026',
          bidsCount: 0,
          description:
              'A redesign of the student portal with improved UX, accessibility, and performance.',
        ),
        MyTenderModel(
          id: 3,
          title: 'Library Solar Upgrade',
          category: 'Energy & Facilities',
          status: 'Open',
          budget: '\$310,000',
          deadline: '02 Jun 2026',
          bidsCount: 11,
          description:
              'Solar panel installation and energy system upgrade for the central library rooftop.',
        ),
        MyTenderModel(
          id: 4,
          title: 'Cafeteria Equipment Renewal',
          category: 'Procurement',
          status: 'Closed',
          budget: '\$128,000',
          deadline: '18 Jul 2026',
          bidsCount: 4,
          description:
              'Replacement of aged kitchen and serving equipment across student cafeterias.',
        ),
        MyTenderModel(
          id: 5,
          title: 'Dormitory Fire Safety Upgrade',
          category: 'Facilities',
          status: 'Open',
          budget: '\$92,000',
          deadline: '28 Jul 2026',
          bidsCount: 2,
          description:
              'A short tender for fire alarm maintenance, signage updates, and safety inspections.',
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  List<MyTenderModel> get filteredTenders {
    if (selectedFilter.value == 'all') {
      return tenders;
    }

    return tenders
        .where((tender) => tender.status.toLowerCase() == selectedFilter.value)
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  int countByStatus(String status) {
    return tenders
        .where((tender) => tender.status.toLowerCase() == status.toLowerCase())
        .length;
  }
}
