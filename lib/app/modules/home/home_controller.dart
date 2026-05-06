import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/home/home_model.dart';

class HomeController extends GetxController {
  var tenderList = <Tender>[].obs;
  var categoryList = <String>[].obs;
  var categoryLookup = <int, String>{}.obs;

  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var isLastPage = false.obs;
  var currentIndex = 0.obs;

  var searchQuery = ''.obs;
  var activeFilters = <String, dynamic>{}.obs;

  final ApiService _apiService = ApiService();
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollCtrl = ScrollController();

  @override
  void onReady() {
    super.onReady();
    loadInitialData();
    debounce(
      searchQuery,
      (_) => refreshAll(),
      time: const Duration(milliseconds: 500),
    );

    // Listen for filter changes
    ever(activeFilters, (_) => refreshAll());
  }

  @override
  void onClose() {
    scrollCtrl.dispose();
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await fetchCategories();
    await fetchNextPage();
    isLoading.value = false;
  }

  Future<void> fetchCategories() async {
    try {
      final List<dynamic> fields = await _apiService.getFields();

      categoryLookup.clear();
      List<String> tempNames = [];

      for (var item in fields) {
        if (item['id'] != null && item['name'] != null) {
          int id = item['id'];
          String name = item['name'].toString();

          categoryLookup[id] = name;
          tempNames.add(name);
        }
      }

      categoryList.assignAll(tempNames);
      print("Mapped ${categoryLookup.length} categories successfully.");
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchNextPage() async {
    if (tenderList.isEmpty) isLoading.value = true;
    try {
      final data = await _apiService.getTenders(
        query: searchQuery.value,
        category: activeFilters['category'],
      );

      print("Raw Data from Tenders API: ${data.length} items found.");

      var items = data
          .map((json) {
            try {
              return Tender.fromJson(json, categoryLookup);
            } catch (e) {
              print("Error parsing single tender: $e");
              return null;
            }
          })
          .whereType<Tender>()
          .toList();

      tenderList.assignAll(items);
    } catch (e) {
      print("General Error fetching tenders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    isRefreshing.value = true;
    await fetchCategories();
    await fetchNextPage();
    isRefreshing.value = false;
  }

  void toggleFavourite(Tender tender) async {
    tender.isFavourite = !tender.isFavourite;
    tenderList.refresh();

    try {
      bool success = await _apiService.toggleSaveTender(
        tender.id,
        tender.isFavourite,
      );
      if (!success) throw Exception("API Failed");
    } catch (e) {
      tender.isFavourite = !tender.isFavourite;
      tenderList.refresh();
      Get.snackbar(
        "Error",
        "Could not save tender. Check your connection.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 1) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (searchFocusNode.canRequestFocus) searchFocusNode.requestFocus();
      });
    } else {
      searchFocusNode.unfocus();
    }
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  void applyFilter(String key, dynamic value) {
    if (activeFilters[key] == value) {
      activeFilters.remove(key);
    } else {
      activeFilters[key] = value;
    }
  }

  void clearAllFilters() {
    activeFilters.clear();
  }
}
