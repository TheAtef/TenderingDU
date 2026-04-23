import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/modules/home/home_model.dart';

class HomeController extends GetxController {
  static const _pageSize = 100000;
  int _currentPage = 1;
  var isLastPage = false.obs;

  var tenderList = <Tender>[].obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;

  var searchQuery = ''.obs;
  var activeFilters = <String, dynamic>{}.obs;
  var currentIndex = 0.obs;

  final Map<int, ScrollController> _scrollControllers = {};

  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  ScrollController? get scrollCtrl => null;

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchQuery,
      (_) => refreshAll(),
      time: const Duration(milliseconds: 500),
    );
    ever(activeFilters, (_) => refreshAll());
    fetchNextPage();
  }

  ScrollController getScrollController(int index) {
    if (!_scrollControllers.containsKey(index)) {
      _scrollControllers[index] = ScrollController();
      _scrollControllers[index]!.addListener(() => _onScroll(index));
    }
    return _scrollControllers[index]!;
  }

  void _onScroll(int index) {
    final ctrl = _scrollControllers[index];
    if (ctrl != null &&
        ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        !isLastPage.value) {
      fetchNextPage();
    }
  }

  @override
  void onClose() {
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  void changeTab(int index) {
    currentIndex.value = index;

    if (index == 1) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (searchFocusNode.canRequestFocus) {
          searchFocusNode.requestFocus();
        }
      });
    } else {
      searchFocusNode.unfocus();
      if (searchQuery.value.isNotEmpty) {
        clearSearch();
      }
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
    await Future.delayed(const Duration(milliseconds: 1500));

    final categories = ['Construction', 'IT', 'Healthcare'];
    final statuses = ['active', 'applied', 'saved'];

    List<Tender> mockDb = List.generate(45, (index) {
      return Tender(
        id: index,
        title: 'Tender Project Title ${index + 1}',
        description: 'Detailed description for tender ${index + 1}',
        deadline: '${10 + (index % 15)} days left',
        category: categories[index % categories.length],
        status: statuses[index % statuses.length],
        isFavourite: index % 4 == 0,
      );
    });

    var filtered = mockDb;

    if (query != null && query.isNotEmpty) {
      filtered = filtered
          .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    if (filters != null && filters.isNotEmpty) {
      if (filters.containsKey('category')) {
        filtered = filtered
            .where((t) => t.category == filters['category'])
            .toList();
      }
      if (filters.containsKey('status')) {
        filtered = filtered
            .where((t) => t.status == filters['status'])
            .toList();
      }
    }

    int startIndex = (page - 1) * _pageSize;
    if (startIndex >= filtered.length) return [];

    int endIndex = startIndex + _pageSize;
    if (endIndex > filtered.length) endIndex = filtered.length;

    return filtered.sublist(startIndex, endIndex);
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
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
      tenderList.refresh();
    }
  }

  void applyFilter(String key, dynamic value) {
    activeFilters[key] = value;
  }

  void clearAllFilters() {
    activeFilters.clear();
  }
}
