import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

import 'my_tenders_controller.dart';
import 'my_tender_model.dart';

class MyTendersView extends GetView<MyTendersController> {
  const MyTendersView({super.key});

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(),
                    const SizedBox(height: 16),
                    _FilterBar(controller: controller),
                    const SizedBox(height: 12),
                    Text(
                      'A simple list of your tenders with a quick status overview.',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _TenderList(controller: controller)),
                  ],
                ),
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
    return Obx(() {
      final theme = ThemeController.to;
      return Row(
        children: [
          AnimatedTap(
            child: GlassIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Get.back(),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'my_tenders'.tr,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: theme.textPrimary,
            ),
          ),
        ],
      );
    });
  }
}

class _FilterBar extends StatelessWidget {
  final MyTendersController controller;

  const _FilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      final filters = [('All', 'all'), ('Open', 'open'), ('Closed', 'closed')];

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: filters.map((filter) {
          final label = filter.$1;
          final value = filter.$2;
          final isActive = controller.selectedFilter.value == value;

          return InkWell(
            onTap: () => controller.setFilter(value),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppColors.actionBlue : theme.cardColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isActive ? Colors.transparent : theme.borderColor,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : theme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _TenderList extends StatelessWidget {
  final MyTendersController controller;

  const _TenderList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      final items = controller.filteredTenders;

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (items.isEmpty) {
        return Center(
          child: Text(
            'No tenders found for this filter.',
            style: TextStyle(color: theme.textSecondary),
          ),
        );
      }

      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _TenderCard(tender: items[index]),
      );
    });
  }
}

class _TenderCard extends StatelessWidget {
  final MyTenderModel tender;

  const _TenderCard({required this.tender});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    final isOpen = tender.status.toLowerCase() == 'open';
    final statusColor = isOpen
        ? const Color(0xFF1E88E5)
        : const Color(0xFF546E7A);
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MY_TENDER_DETAILS, arguments: tender),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.description_outlined,
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tender.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tender.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tender.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tender.category,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
