import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
          child: Row(
            children: [
              Text(
                "saved_tenders".tr,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeController.to.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.savedList.isEmpty) {
              return Center(
                child: Text(
                  "no_saved".tr,
                  style: TextStyle(color: ThemeController.to.textSecondary),
                ),
              );
            }

            final isDesktop = ResponsiveLayout.isDesktop(context);

            return AnimationLimiter(
              child: isDesktop
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 450,
                            mainAxisExtent: 180,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: controller.savedList.length,
                      itemBuilder: (context, index) {
                        return _buildAnimatedCard(
                          controller.savedList[index],
                          index,
                          isDesktop,
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      itemCount: controller.savedList.length,
                      itemBuilder: (context, index) {
                        return _buildAnimatedCard(
                          controller.savedList[index],
                          index,
                          isDesktop,
                        );
                      },
                    ),
            );
          }),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildAnimatedCard(dynamic tender, int index, bool isDesktop) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 400),
      child: SlideAnimation(
        verticalOffset: 50,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.TENDER_DETAILS, arguments: tender),
            child: _TenderCard(
              title: tender.title,
              category: tender.category,
              deadline: tender.deadline is DateTime
                  ? tender.deadline.toString().split(' ')[0]
                  : tender.deadline,
              isBookmarked: true,
              onBookmark: () => controller.removeFromSaved(tender),
              margin: isDesktop
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(bottom: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class _TenderCard extends StatelessWidget {
  final String title, category, deadline;
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
                  icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
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
