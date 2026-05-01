import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/modules/home/home_model.dart';

class HomeController extends GetxController {
  int _currentPage = 1;
  var isLastPage = false.obs;

  var tenderList = <Tender>[].obs;
  var categoryList = <String>[].obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;

  var searchQuery = ''.obs;
  var activeFilters = <String, dynamic>{}.obs;
  var currentIndex = 0.obs;

  final ApiService _apiService = ApiService();
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollCtrl = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchNextPage();

    debounce(
      searchQuery,
      (_) => refreshAll(),
      time: const Duration(milliseconds: 500),
    );
    ever(activeFilters, (_) => refreshAll());
  }

  @override
  void onClose() {
    scrollCtrl.dispose();
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void fetchCategories() async {
    try {
      final fields = await _apiService.getFields();
      categoryList.value = fields.map((f) => f['name'].toString()).toList();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchNextPage() async {
    isLoading.value = true;
    try {
      final data = await _apiService.getTenders(
        query: searchQuery.value,
        category: activeFilters['category'],
      );
      tenderList.assignAll(data.map((json) => Tender.fromJson(json)).toList());
    } catch (e) {
      print("Error fetching tenders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    isRefreshing.value = true;
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
      Get.snackbar("Error", "Could not save tender");
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
