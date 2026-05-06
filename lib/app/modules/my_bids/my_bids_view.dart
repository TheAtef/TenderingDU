import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
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
                          title: Text(
                            'applied'.tr,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            'applied_hint'.tr,
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
                          title: Text(
                            'history'.tr,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            'history_hint'.tr,
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

// ignore: must_be_immutable
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
                    "${"category".tr}: $category",
                    style: TextStyle(fontSize: 12, color: theme.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  if (deadline != null)
                    InfoPill(icon: Icons.schedule, label: deadline!),
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
