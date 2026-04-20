import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/modules/my_bids/my_bids_controller.dart';

class BidsView extends GetView<BidsController> {
  const BidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: Stack(
          children: [
            const _StaticBackground(),
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _Header(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(iconTheme: const IconThemeData(size: 40)),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.only(bottom: 10),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: theme.borderColor,
                              width: 2,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: theme.borderColor,
                              width: 2,
                            ),
                          ),
                          title: const Text(
                            'Applied',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: const Text(
                            'Bids you have applied for',
                            style: TextStyle(fontSize: 14),
                          ),
                          initiallyExpanded: true,

                          children: [
                            Obx(() {
                              if (controller.isLoading.value) {
                                return Column(
                                  children: List.generate(
                                    3,
                                    (_) => const _ShimmerCard(),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      NeverScrollableScrollPhysics(), // Delegate scrolling to the parent
                                  itemCount: controller.appliedList.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.appliedList[index];
                                    return _ResultItem(
                                      title: item.title,
                                      category: item.category,
                                      deadline: item.deadline,
                                      onTap: () => Get.toNamed(
                                        '/tender-details',
                                        arguments: item,
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(iconTheme: const IconThemeData(size: 40)),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.only(bottom: 10),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: theme.borderColor,
                              width: 2,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: theme.borderColor,
                              width: 2,
                            ),
                          ),
                          title: const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: const Text(
                            'Bids in your history',
                            style: TextStyle(fontSize: 14),
                          ),
                          children: [
                            Obx(() {
                              if (controller.isLoading.value) {
                                return Column(
                                  children: List.generate(
                                    3,
                                    (_) => const _ShimmerCard(),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      NeverScrollableScrollPhysics(), // Delegate scrolling to the parent
                                  itemCount: controller.historyList.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.historyList[index];
                                    return _ResultItem(
                                      title: item.title,
                                      category: item.category,
                                      result: item.isWinningBid,
                                      onTap: () => Get.toNamed(
                                        '/tender-details',
                                        arguments: item,
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _StaticBackground extends StatelessWidget {
  const _StaticBackground();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: _Glow(color: theme.glowBlue, size: 300),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: _Glow(color: theme.glowPurple, size: 250),
            ),
          ],
        ),
      );
    });
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Obx(() {
          final theme = ThemeController.to;
          return Row(
            children: [
              _AnimatedTap(
                child: _GlassIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "My Bids",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: theme.textPrimary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: theme.isDarkMode
                ? Colors.white10
                : AppColors.actionBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.borderColor),
          ),
          child: Icon(icon, color: theme.textPrimary, size: 20),
        ),
      );
    });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.97),
      onTapUp: (_) => setState(() => scale = 1),
      onTapCancel: () => setState(() => scale = 1),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderColor),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String title;
  final String category;
  String? deadline;
  bool? result;
  final VoidCallback onTap;

  _ResultItem({
    required this.title,
    required this.category,
    required this.onTap,
    this.deadline,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.actionBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.description_outlined,
                color: AppColors.actionBlue,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Category: $category",
                    style: TextStyle(fontSize: 12, color: theme.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  if (deadline != null)
                    _InfoPill(
                      icon: Icon(
                        Icons.schedule,
                        size: 14,
                        color: theme.textSecondary,
                      ),
                      label: deadline!,
                    ),
                  if (result != null)
                    _InfoPill(
                      icon: result == true
                          ? Icon(
                              Icons.check_circle_outlined,
                              size: 14,
                              color: Color(0xFF4CAF50),
                            )
                          : Icon(
                              Icons.not_interested_outlined,
                              size: 14,
                              color: Color(0xFFF44336),
                            ),
                      label: result == true ? "Won Tender" : "Lost Tender",
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final Icon icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        width: 105,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: theme.isDarkMode
              ? Colors.white10
              : AppColors.actionBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: theme.textPrimary, fontSize: 12),
            ),
          ],
        ),
      );
    });
  }
}
