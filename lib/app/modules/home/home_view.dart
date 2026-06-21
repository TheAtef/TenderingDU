import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/modules/create_tender/create_tender_controller.dart';
import 'package:tendering_du/app/modules/create_tender/create_tender_view.dart';
import 'package:tendering_du/app/modules/profile/profile_view.dart';
import 'package:tendering_du/app/modules/receivedBids/received_bids_controller.dart';
import 'package:tendering_du/app/modules/receivedBids/received_bids_view.dart';
import 'package:tendering_du/app/modules/saved/saved_controller.dart';
import 'package:tendering_du/app/modules/saved/saved_view.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_controller.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_view.dart';
import 'package:tendering_du/app/modules/tender_results/tender_results_controller.dart';
import 'package:tendering_du/app/modules/tender_results/tender_results_view.dart';
import 'home_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      drawer: ResponsiveLayout.isMobile(context) ? const _Drawer() : null,
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(theme),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Stack(
      children: [
        const Positioned.fill(child: StaticBackground()),
        Positioned.fill(
          child: Obx(
            () => _buildIndexedContent(controller.currentIndex.value, false),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: _FloatingActionHub(controller: controller),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(ThemeController theme) {
    return Column(
      children: [
        _DesktopTopNavBar(controller: controller),
        Expanded(
          child: Stack(
            children: [
              const StaticBackground(),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: Obx(
                    () => _buildIndexedContent(
                      controller.currentIndex.value,
                      true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndexedContent(int index, bool isDesktop) {
    if (index == 2) {
      final savedController = Get.isRegistered<SavedController>()
          ? Get.find<SavedController>()
          : Get.put(SavedController());
      savedController.refreshData();
    }

    return IndexedStack(
      index: index,
      children: [
        isDesktop
            ? _DesktopMainContent(controller: controller)
            : _MainContent(controller: controller),
        isDesktop
            ? _DesktopMainContent(controller: controller)
            : _MainContent(controller: controller),
        const SavedView(),
        const ProfileView(),
      ],
    );
  }
}

class _DesktopTopNavBar extends StatelessWidget {
  final HomeController controller;
  const _DesktopTopNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    final ApiService apiService = ApiService();

    return Obx(() {
      return Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(
            bottom: BorderSide(color: theme.borderColor, width: 1),
          ),
          boxShadow: [
            if (!theme.isDarkMode)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.gavel_rounded,
                  color: AppColors.actionBlue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  "Tendering DU",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 50),

            Row(
              children: [
                _DesktopNavItem(
                  title: "home".tr,
                  index: 0,
                  controller: controller,
                ),
                _DesktopNavItem(
                  title: "search".tr,
                  index: 1,
                  controller: controller,
                ),
                _DesktopNavItem(
                  title: "saved".tr,
                  index: 2,
                  controller: controller,
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: controller.searchTextController,
                focusNode: controller.searchFocusNode,
                onChanged: (val) {
                  controller.changeTab(1);
                  controller.searchQuery.value = val;
                },
                decoration: InputDecoration(
                  hintText: "search_hint".tr,
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: theme.backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),

            ElevatedButton.icon(
              onPressed: () {
                Get.lazyPut(() => CreateTenderController());
                Get.to(() => const CreateTenderView());
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text("create_tender".tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: 16),

            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: theme.textSecondary,
              ),
              onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
            ),

            PopupMenuButton<String>(
              offset: const Offset(0, 50),
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.actionBlue.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: AppColors.actionBlue,
                  size: 20,
                ),
              ),
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                if (value == 'profile') controller.changeTab(3);
                if (value == 'my_bids') Get.toNamed(Routes.MYBIDS);
                if (value == 'received_bids') {
                  Get.lazyPut(() => ReceivedBidsController());
                  Get.to(() => const ReceivedBidsView());
                }
                if (value == 'results') {
                  Get.lazyPut(() => TenderResultsController());
                  Get.to(() => const TenderResultsView());
                }
                if (value == 'settings') Get.toNamed(Routes.SETTINGS);
                if (value == 'logout') {
                  await apiService.logout();
                  Get.offAllNamed(Routes.LOGIN);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Text(
                    "profile".tr,
                    style: TextStyle(color: theme.textPrimary),
                  ),
                ),
                PopupMenuItem(
                  value: 'my_bids',
                  child: Text(
                    "my_bids".tr,
                    style: TextStyle(color: theme.textPrimary),
                  ),
                ),
                PopupMenuItem(
                  value: 'received_bids',
                  child: Text(
                    "received_bids".tr,
                    style: TextStyle(color: theme.textPrimary),
                  ),
                ),
                PopupMenuItem(
                  value: 'results',
                  child: Text(
                    "tenders_results".tr,
                    style: TextStyle(color: theme.textPrimary),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'settings',
                  child: Text(
                    "settings".tr,
                    style: TextStyle(color: theme.textPrimary),
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text(
                    "logout".tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _DesktopNavItem extends StatelessWidget {
  final String title;
  final int index;
  final HomeController controller;

  const _DesktopNavItem({
    required this.title,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return InkWell(
      onTap: () => controller.changeTab(index),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Obx(() {
          final isActive = controller.currentIndex.value == index;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.actionBlue : theme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: isActive ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.actionBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DesktopMainContent extends StatelessWidget {
  final HomeController controller;
  const _DesktopMainContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 280,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Stats",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeController.to.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DesktopQuickStats(controller: controller),
                  const SizedBox(height: 40),
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeController.to.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _DesktopCategoryList(controller: controller),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),

          Expanded(
            child: CustomScrollView(
              controller: controller.scrollCtrl,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DesktopHeroBanner(),
                      const SizedBox(height: 40),
                      Text(
                        "Latest Tenders",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ThemeController.to.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                _TenderCardsSection(controller: controller),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.actionBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.actionBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "greetings".tr,
            style: TextStyle(fontSize: 18, color: theme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            "discover_tenders".tr,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: theme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Find the best opportunities for your business, manage bids, and grow your revenue all in one place.",
            style: TextStyle(fontSize: 16, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DesktopQuickStats extends StatelessWidget {
  final HomeController controller;
  const _DesktopQuickStats({required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = [
      ["active".tr, "24", const Color(0xFF667EEA), Icons.local_fire_department],
      ["applied".tr, "8", const Color(0xFF4FACFE), Icons.check_circle_outline],
    ];

    return Column(
      children: data.map((item) {
        return InkWell(
          onTap: () {
            if (item[0] == "Active") controller.applyFilter("status", "active");
            if (item[0] == "Applied")
              controller.applyFilter("status", "applied");
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (item[2] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: (item[2] as Color).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(item[3] as IconData, color: item[2] as Color, size: 32),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item[1] as String,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: item[2] as Color,
                      ),
                    ),
                    Text(
                      item[0] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeController.to.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DesktopCategoryList extends StatelessWidget {
  final HomeController controller;
  const _DesktopCategoryList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      final categories = ["all".tr, ...controller.categoryList];
      final activeCategory = controller.activeFilters["category"];

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: categories.asMap().entries.map((entry) {
          int i = entry.key;
          String name = entry.value;
          final isActive =
              activeCategory == name || (i == 0 && activeCategory == null);

          return InkWell(
            onTap: () {
              if (i == 0) {
                controller.clearAllFilters();
              } else {
                controller.applyFilter("category", name);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppColors.actionBlue : theme.cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? Colors.transparent : theme.borderColor,
                ),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: isActive ? Colors.white : theme.textPrimary,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _MainContent extends StatelessWidget {
  final HomeController controller;
  const _MainContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshAll,
      child: CustomScrollView(
        controller: controller.scrollCtrl,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HeroHeader(controller: controller),
          _QuickStatsSection(controller: controller),
          _CategoryChips(controller: controller),
          _TenderCardsSection(controller: controller),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final HomeController controller;
  const _HeroHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Obx(() {
          final theme = ThemeController.to;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => AnimatedTap(
                      child: GlassIconButton(
                        icon: Icons.menu,
                        onTap: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      AnimatedTap(
                        child: GlassIconButton(
                          icon: Icons.notifications_rounded,
                          onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "greetings".tr,
                style: TextStyle(fontSize: 16, color: theme.textSecondary),
              ),
              Text(
                "discover_tenders".tr,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: theme.textPrimary,
                ),
              ),
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: controller.currentIndex.value == 1
                      ? _SearchBar(controller: controller)
                      : const SizedBox(width: double.infinity, height: 0),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _QuickStatsSection extends StatelessWidget {
  final HomeController controller;
  const _QuickStatsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = [
      ["active".tr, "24", const Color(0xFF667EEA)],
      ["applied".tr, "8", const Color(0xFF4FACFE)],
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                switch (data[index][0]) {
                  case "Active":
                    controller.applyFilter("status", "active");
                    break;
                  case "Applied":
                    controller.applyFilter("status", "applied");
                    break;
                }
              },
              child: _StatCard(
                label: data[index][0] as String,
                value: data[index][1] as String,
                color: data[index][2] as Color,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(theme.isDarkMode ? 0.15 : 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.isDarkMode ? Colors.white : color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.isDarkMode ? Colors.white70 : theme.textSecondary,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _CategoryChips extends StatelessWidget {
  final HomeController controller;
  const _CategoryChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final theme = ThemeController.to;
        final categories = ["all".tr, ...controller.categoryList];
        final activeCategory = controller.activeFilters["category"];

        return Container(
          height: 45,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final isActive =
                  activeCategory == categories[i] ||
                  (i == 0 && activeCategory == null);

              return GestureDetector(
                onTap: () {
                  if (i == 0) {
                    controller.clearAllFilters();
                  } else {
                    controller.applyFilter("category", categories[i]);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.actionBlue : theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? Colors.transparent : theme.borderColor,
                    ),
                  ),
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      color: isActive ? Colors.white : theme.textPrimary,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _TenderCardsSection extends StatelessWidget {
  final HomeController controller;
  const _TenderCardsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.tenderList.isEmpty) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, _) => const _ShimmerCard(),
            childCount: 5,
          ),
        );
      }

      if (controller.tenderList.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                "no_tenders_available".tr,
                style: TextStyle(color: ThemeController.to.textSecondary),
              ),
            ),
          ),
        );
      }

      final isDesktop = ResponsiveLayout.isDesktop(context);

      return SliverPadding(
        padding: isDesktop
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 24),
        sliver: AnimationLimiter(
          child: isDesktop
              ? SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 180,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildAnimatedCard(index, isDesktop);
                  }, childCount: controller.tenderList.length),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildAnimatedCard(index, isDesktop);
                  }, childCount: controller.tenderList.length),
                ),
        ),
      );
    });
  }

  Widget _buildAnimatedCard(int index, bool isDesktop) {
    final tender = controller.tenderList[index];

    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 400),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: AnimatedTap(
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => const TenderDetailsView(),
                  binding: BindingsBuilder(() {
                    Get.put(TenderDetailsController());
                  }),
                  arguments: tender,
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _TenderCard(
                  title: tender.title,
                  category: tender.category,
                  deadline: tender.daysLeft,
                  isBookmarked: tender.isFavourite,
                  onBookmark: () => controller.toggleFavourite(tender),
                  margin: isDesktop
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(bottom: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TenderCard extends StatelessWidget {
  final String title;
  final String category;
  final String deadline;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final EdgeInsetsGeometry? margin;

  const _TenderCard({
    required this.title,
    required this.category,
    required this.deadline,
    required this.isBookmarked,
    required this.onBookmark,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Obx(() {
      final theme = ThemeController.to;

      Widget titleWidget = Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.textPrimary,
          height: 1.3,
        ),
      );

      return Container(
        margin: margin ?? const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.borderColor),
          boxShadow: theme.isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: isDesktop ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.actionBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onBookmark,
                  icon: Icon(
                    isBookmarked ? Icons.favorite : Icons.favorite_border,
                    color: isBookmarked ? Colors.red : theme.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isDesktop) Expanded(child: titleWidget) else titleWidget,
            if (isDesktop) const Spacer() else const SizedBox(height: 16),
            Row(
              children: [
                const InfoPill(icon: Icons.attach_money, label: "\$2.5M"),
                const SizedBox(width: 12),
                InfoPill(icon: Icons.schedule, label: deadline),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _FloatingActionHub extends StatelessWidget {
  final HomeController controller;
  const _FloatingActionHub({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final theme = ThemeController.to;
        final currentIndex = controller.currentIndex.value;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.isDarkMode
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: theme.borderColor),
              boxShadow: theme.isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HubButton(
                  icon: Icons.home_rounded,
                  label: "home".tr,
                  active: currentIndex == 0,
                  onTap: () => controller.changeTab(0),
                ),
                _HubButton(
                  icon: Icons.search_rounded,
                  label: "search".tr,
                  active: currentIndex == 1,
                  onTap: () => controller.changeTab(1),
                ),
                _HubButton(
                  icon: Icons.bookmark_rounded,
                  label: "saved".tr,
                  active: currentIndex == 2,
                  onTap: () => controller.changeTab(2),
                ),
                _HubButton(
                  icon: Icons.person_rounded,
                  label: "profile".tr,
                  active: currentIndex == 3,
                  onTap: () => controller.changeTab(3),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _HubButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _HubButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      final inactiveColor = theme.textSecondary;

      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? AppColors.actionBlue.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: active ? AppColors.actionBlue : inactiveColor,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: active ? AppColors.actionBlue : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.borderColor),
        ),
      );
    });
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();

    return Obx(() {
      final theme = ThemeController.to;
      return Drawer(
        backgroundColor: theme.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "menu".tr,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _DrawerItem(
                  icon: Icons.assignment_turned_in,
                  title: "tenders_results".tr,
                  onTap: () {
                    Get.back();
                    Get.lazyPut(() => TenderResultsController());
                    Get.to(() => const TenderResultsView());
                  },
                ),
                _DrawerItem(
                  icon: Icons.construction_rounded,
                  title: "create_tender".tr,
                  onTap: () {
                    Get.back();
                    Get.lazyPut(() => CreateTenderController());
                    Get.to(() => const CreateTenderView());
                  },
                ),
                _DrawerItem(
                  icon: Icons.gavel_rounded,
                  title: "received_bids".tr,
                  onTap: () {
                    Get.back();
                    Get.lazyPut(() => ReceivedBidsController());
                    Get.to(() => const ReceivedBidsView());
                  },
                ),
                _DrawerItem(
                  icon: Icons.monetization_on_rounded,
                  title: "my_bids".tr,
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.MYBIDS);
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings_rounded,
                  title: "settings".tr,
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.SETTINGS);
                  },
                ),

                const Spacer(),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  title: "logout".tr,
                  isDestructive: true,
                  onTap: () async {
                    await _apiService.logout();
                    Get.offAllNamed(Routes.LOGIN);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      final color = isDestructive ? Colors.redAccent : AppColors.actionBlue;

      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.borderColor),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: isDestructive ? Colors.redAccent : theme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SearchBar extends StatelessWidget {
  final HomeController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        margin: const EdgeInsets.only(top: 24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.borderColor),
        ),
        child: TextField(
          controller: controller.searchTextController,
          focusNode: controller.searchFocusNode,
          onChanged: (val) => controller.searchQuery.value = val,
          style: TextStyle(color: theme.textPrimary, fontSize: 15),
          cursorColor: AppColors.actionBlue,
          decoration: InputDecoration(
            hintText: "search_hint".tr,
            hintStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.textSecondary,
              size: 22,
            ),
            suffixIcon: controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: theme.textSecondary,
                      size: 18,
                    ),
                    onPressed: controller.clearSearch,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      );
    });
  }
}
