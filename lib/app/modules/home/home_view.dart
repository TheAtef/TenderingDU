import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/modules/profile/profile_view.dart';
import 'home_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      drawer: const _Drawer(),
      body: Stack(
        children: [
          const _StaticBackground(),
          Obx(() {
            if (controller.currentIndex.value != 3) {
              return _MainContent(controller: controller);
            } else {
              return ProfileView();
            }
          }),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _FloatingActionHub(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _StaticBackground extends StatelessWidget {
  const _StaticBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B2A), Color(0xFF1B2846), Color(0xFF273557)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: _Glow(
              color: AppColors.actionBlue.withOpacity(0.2),
              size: 300,
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: _Glow(color: Colors.purple.withOpacity(0.1), size: 250),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => _AnimatedTap(
                    child: _GlassIconButton(
                      icon: Icons.menu,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    _AnimatedTap(
                      child: _GlassIconButton(
                        icon: Icons.notifications_rounded,
                        onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Good Morning,",
              style: TextStyle(fontSize: 16, color: AppColors.greyBlue),
            ),
            const Text(
              "Discover Tenders",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
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
        ),
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
      ["Active", "24", Color(0xFF667EEA)],
      ["Saved", "12", Color(0xFFF5576C)],
      ["Applied", "8", Color(0xFF4FACFE)],
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
                  case "Saved":
                    // Get.offNamed(Routes.SAVED);
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
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
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
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                "No tenders available",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: AnimationLimiter(
          child: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final tender = controller.tenderList[index];

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: _AnimatedTap(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.TENDER_DETAILS, arguments: tender);
                        },
                        child: _TenderCard(
                          title: tender.title,
                          category: tender.category,
                          deadline: tender.deadline,
                          isBookmarked: tender.isFavourite,
                          onBookmark: () => controller.toggleFavourite(tender),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: controller.tenderList.length),
          ),
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
    final categories = ["All", "Construction", "IT", "Healthcare"];

    return SliverToBoxAdapter(
      child: Obx(() {
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
                  if (categories[i] == "All") {
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
                    color: isActive ? AppColors.actionBlue : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categories[i],
                    style: const TextStyle(color: Colors.white, fontSize: 13),
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

class _TenderCard extends StatelessWidget {
  final String title;
  final String category;
  final String deadline;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  const _TenderCard({
    required this.title,
    required this.category,
    required this.deadline,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: AppColors.actionBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: onBookmark,
                icon: Icon(
                  isBookmarked ? Icons.favorite : Icons.favorite_border,
                  color: isBookmarked ? Colors.red : Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const _InfoPill(icon: Icons.attach_money, label: "\$2.5M"),
              const SizedBox(width: 12),
              _InfoPill(icon: Icons.schedule, label: deadline),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedTap extends StatefulWidget {
  final Widget child;
  const _AnimatedTap({required this.child});

  @override
  State<_AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<_AnimatedTap> {
  double scale = 1;

  void _onTapDown(_) => setState(() => scale = 0.95);
  void _onTapUp(_) => setState(() => scale = 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => scale = 1),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.greyBlue),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FloatingActionHub extends StatelessWidget {
  final HomeController controller;
  const _FloatingActionHub({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        final currentIndex = controller.currentIndex.value;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HubButton(
                  icon: Icons.home_rounded,
                  label: "Home",
                  active: currentIndex == 0,
                  onTap: () => controller.changeTab(0),
                ),
                _HubButton(
                  icon: Icons.search_rounded,
                  label: "Search",
                  active: currentIndex == 1,
                  onTap: () => controller.changeTab(1),
                ),
                _HubButton(
                  icon: Icons.bookmark_rounded,
                  label: "Saved",
                  active: currentIndex == 2,
                  onTap: () => controller.changeTab(2),
                ),
                _HubButton(
                  icon: Icons.person_rounded,
                  label: "Profile",
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
              color: active ? AppColors.actionBlue : AppColors.greyBlue,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: active ? AppColors.actionBlue : AppColors.greyBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int? badge;
  const _GlassIconButton({required this.icon, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();
  @override
  Widget build(BuildContext context) => Container(
    height: 150,
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(24),
    ),
  );
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkNavy,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              _DrawerItem(
                icon: Icons.bar_chart_rounded,
                title: "Reports & Performance",
                onTap: () {
                  Get.back();
                  // Get.toNamed(Routes.REPORTS);
                },
              ),

              _DrawerItem(
                icon: Icons.settings_rounded,
                title: "Settings",
                onTap: () {
                  Get.back();
                  // Get.toNamed(Routes.SETTINGS);
                },
              ),

              _DrawerItem(
                icon: Icons.description_rounded,
                title: "Legal Information",
                onTap: () {
                  Get.back();
                  // Get.toNamed(Routes.LEGAL);
                },
              ),

              const Spacer(),

              _DrawerItem(
                icon: Icons.logout_rounded,
                title: "Logout",
                isDestructive: true,
                onTap: () {
                  Get.back();

                  // controller.logout();
                  // Get.offAllNamed(Routes.LOGIN);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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
    final color = isDestructive ? Colors.redAccent : AppColors.actionBlue;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final HomeController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Obx(
        () => TextField(
          controller: controller.searchTextController,
          focusNode: controller.searchFocusNode,
          onChanged: (val) => controller.searchQuery.value = val,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: AppColors.actionBlue,
          decoration: InputDecoration(
            hintText: "Search tenders, categories...",
            hintStyle: const TextStyle(color: AppColors.greyBlue, fontSize: 14),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.greyBlue,
              size: 22,
            ),
            suffixIcon: controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppColors.greyBlue,
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
      ),
    );
  }
}
