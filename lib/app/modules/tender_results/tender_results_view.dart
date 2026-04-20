import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'tender_results_controller.dart';

class TenderResultsView extends GetView<TenderResultsController> {
  const TenderResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: theme.backgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.textPrimary),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Tender Results",
                style: TextStyle(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.actionBlue),
                ),
              );
            }

            // Empty State Handling
            if (controller.tenders.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No tenders found",
                    style: TextStyle(color: theme.textSecondary),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = controller.tenders[index];
                return _ResultItem(
                  title: item.title,
                  category: item.category,
                  onTap: () => Get.toNamed('/tender-details', arguments: item),
                );
              }, childCount: controller.tenders.length),
            );
          }),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String title;
  final String category;
  final VoidCallback onTap;

  const _ResultItem({
    required this.title,
    required this.category,
    required this.onTap,
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
