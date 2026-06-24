import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

// Make sure this points to the correct file where BidsController is located!
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
            const StaticBackground(),
            ResponsiveLayout(
              mobile: _buildMobileLayout(context, theme),
              desktop: _buildDesktopLayout(context, theme),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMobileLayout(BuildContext context, ThemeController theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SafeArea(
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
                      childrenPadding: const EdgeInsets.only(bottom: 10),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: theme.borderColor, width: 2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: theme.borderColor, width: 2),
                      ),
                      title: Text(
                        'applied'.tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        'applied_hint'.tr,
                        style: const TextStyle(fontSize: 14),
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
                            if (controller.appliedList.isEmpty) {
                              return _EmptyState(message: "no_bids_applied".tr);
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.appliedList.length,
                              itemBuilder: (context, index) {
                                final item = controller.appliedList[index];
                                return _ResultItem(
                                  title: item.tenderTitle,
                                  subLabel:
                                      "Bid Amount: \$${item.totalPrice.toStringAsFixed(2)}",
                                  duration: item.estimatedDuration,
                                  onTap: () => Get.toNamed(
                                    Routes.BID_DETAILS,
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
                      childrenPadding: const EdgeInsets.only(bottom: 10),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: theme.borderColor, width: 2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: theme.borderColor, width: 2),
                      ),
                      title: Text(
                        'history'.tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        'history_hint'.tr,
                        style: const TextStyle(fontSize: 14),
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
                            if (controller.historyList.isEmpty) {
                              return _EmptyState(message: "no_bid_history".tr);
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.historyList.length,
                              itemBuilder: (context, index) {
                                final item = controller.historyList[index];
                                return _ResultItem(
                                  title: item.tenderTitle,
                                  subLabel:
                                      "Bid Amount: \$${item.totalPrice.toStringAsFixed(2)}",
                                  result:
                                      item.statusName.toLowerCase() ==
                                      'awarded',
                                  onTap: () => Get.toNamed(
                                    Routes.BID_DETAILS,
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
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeController theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12),
                    hoverColor: AppColors.actionBlue.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: theme.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "back".tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    "my_bids".tr,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: theme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDesktopPanel(
                        title: 'applied'.tr,
                        subtitle: 'applied_hint'.tr,
                        list: controller.appliedList,
                        isHistory: false,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: _buildDesktopPanel(
                        title: 'history'.tr,
                        subtitle: 'history_hint'.tr,
                        list: controller.historyList,
                        isHistory: true,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopPanel({
    required String title,
    required String subtitle,
    required List<dynamic> list,
    required bool isHistory,
    required ThemeController theme,
  }) {
    return Container(
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
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.actionBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${list.length}",
                      style: const TextStyle(
                        color: AppColors.actionBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.borderColor),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 4,
                  itemBuilder: (_, __) => const _ShimmerCard(),
                );
              }

              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_open_rounded,
                          size: 64,
                          color: theme.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isHistory
                              ? "no_bid_history".tr
                              : "no_bids_applied".tr,
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return _DesktopResultItem(
                    title: item.tenderTitle,
                    subLabel: "Amount: \$${item.totalPrice.toStringAsFixed(2)}",
                    duration: isHistory ? null : item.estimatedDuration,
                    result: isHistory
                        ? (item.statusName.toLowerCase() == 'awarded')
                        : null,
                    onTap: () =>
                        Get.toNamed(Routes.BID_DETAILS, arguments: item),
                  );
                },
              );
            }),
          ),
        ],
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
              AnimatedTap(
                child: GlassIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "my_bids".tr,
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

class _ResultItem extends StatelessWidget {
  final String title;
  final String subLabel;
  final String? duration;
  final bool? result;
  final VoidCallback onTap;

  const _ResultItem({
    required this.title,
    required this.subLabel,
    required this.onTap,
    this.duration,
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
              child: const Icon(
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
                    subLabel,
                    style: TextStyle(fontSize: 13, color: theme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  if (duration != null && duration!.isNotEmpty)
                    InfoPill(icon: Icons.schedule, label: duration!),
                  if (result != null)
                    InfoPill(
                      icon: Icons.check_circle_outlined,
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

class _DesktopResultItem extends StatelessWidget {
  final String title;
  final String subLabel;
  final String? duration;
  final bool? result;
  final VoidCallback onTap;

  const _DesktopResultItem({
    required this.title,
    required this.subLabel,
    required this.onTap,
    this.duration,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          hoverColor: AppColors.actionBlue.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.borderColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.actionBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                if (duration != null && duration!.isNotEmpty)
                  InfoPill(icon: Icons.schedule, label: duration!),
                if (result != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: result!
                          ? AppColors.successGreen.withOpacity(0.1)
                          : AppColors.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          result!
                              ? Icons.emoji_events_rounded
                              : Icons.cancel_rounded,
                          size: 14,
                          color: result!
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          result! ? "Won" : "Lost",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: result!
                                ? AppColors.successGreen
                                : AppColors.errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: ThemeController.to.textSecondary),
        ),
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
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderColor),
      ),
    );
  }
}
