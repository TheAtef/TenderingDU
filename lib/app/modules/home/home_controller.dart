import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

class Tender {
  final int id;
  final String title;
  final String description;
  final String deadline;
  bool isFavourite;

  Tender({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isFavourite = false,
  });

  factory Tender.fromJson(Map<String, dynamic> json) => Tender(
    id: json['id'] as int,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    deadline: json['deadline'] ?? '',
    isFavourite: json['is_favourite'] == true,
  );
}

class HomeController extends GetxController {
  static const _pageSize = 20;
  int _currentPage = 1;
  var isLastPage = false.obs;

  var tenderList = <Tender>[].obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;

  var searchQuery = ''.obs;
  var activeFilters = <String, dynamic>{}.obs;

  var currentIndex = 0.obs;

  final ScrollController scrollCtrl = ScrollController();

  static const _baseUrl = 'ddd';

  @override
  void onInit() {
    super.onInit();

    scrollCtrl.addListener(_onScroll);

    ever(searchQuery, (_) => refreshAll());
    ever(activeFilters, (_) => refreshAll());

    fetchNextPage();
  }

  @override
  void onClose() {
    scrollCtrl.removeListener(_onScroll);
    scrollCtrl.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;

    switch (index) {
      case 0:
        break;
      case 1:
        // Get.offNamed(Routes.SEARCH);
        break;
      case 2:
        // Get.offNamed(Routes.SAVED);
        break;
      case 3:
        //Get.offNamed(Routes.PROFILE);
        break;
    }
  }

  void _onScroll() {
    if (scrollCtrl.position.pixels >=
            scrollCtrl.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        !isLastPage.value) {
      fetchNextPage();
    }
  }

  Future<void> refreshAll() async {
    isRefreshing.value = true;

    _currentPage = 1;
    isLastPage.value = false;
    tenderList.clear();

    await fetchNextPage();

    isRefreshing.value = false;
  }

  Future<List<Tender>> _fetchFromServer({
    required int page,
    String? query,
    Map<String, dynamic>? filters,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'page': page.toString(),
        'page_size': _pageSize.toString(),
        if (query != null && query.isNotEmpty) 'search': query,
        if (filters != null)
          ...filters.map((k, v) => MapEntry(k, v.toString())),
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }

    final json = jsonDecode(response.body);

    final List data = (json is Map && json['results'] != null)
        ? json['results']
        : json;

    return data.map((e) => Tender.fromJson(e)).toList();
  }

  Future<void> fetchNextPage() async {
    if (isLoading.value || isLastPage.value) return;

    isLoading.value = true;

    try {
      final newItems = await _fetchFromServer(
        page: _currentPage,
        query: searchQuery.value,
        filters: activeFilters,
      );

      if (newItems.length < _pageSize) {
        isLastPage.value = true;
      }

      tenderList.addAll(newItems);
      _currentPage++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColors.errorRed,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavourite(Tender tender) {
    tender.isFavourite = !tender.isFavourite;

    final idx = tenderList.indexWhere((t) => t.id == tender.id);
    if (idx != -1) {
      tenderList[idx] = tender;
    }
  }

  void applyFilter(String key, dynamic value) {
    activeFilters[key] = value;
  }

  void clearAllFilters() {
    activeFilters.clear();
  }
}
