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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(controller: controller),
                    const SizedBox(height: 18),
                    _FilterBar(controller: controller),
                    const SizedBox(height: 14),
                    Text(
                      'Browse your submitted tenders and jump into their details.',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 14,
                        height: 1.4,
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
  final MyTendersController controller;

  const _Header({required this.controller});

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'my_tenders'.tr,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.tenders.length} tenders tracked',
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
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isActive ? AppColors.actionBlue : theme.cardColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isActive ? Colors.transparent : theme.borderColor,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.actionBlue.withOpacity(0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
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
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 34,
                  color: theme.textSecondary.withOpacity(0.8),
                ),
                const SizedBox(height: 10),
                Text(
                  'No tenders found for this filter.',
                  style: TextStyle(color: theme.textSecondary),
                ),
              ],
            ),
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

    final accentColor = isOpen
        ? const Color(0xFF1E88E5)
        : const Color(0xFF546E7A);

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MY_TENDER_DETAILS, arguments: tender),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                theme.backgroundColor == Colors.white ? 0.04 : 0.12,
              ),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.95),
                          accentColor.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withOpacity(0.18),
                            accentColor.withOpacity(0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accentColor.withOpacity(0.14),
                        ),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: accentColor,
                        size: 23,
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
                                    fontWeight: FontWeight.w800,
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
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.18),
                                  ),
                                ),
                                child: Text(
                                  tender.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _MetaChip(
                                icon: Icons.sell_outlined,
                                label: tender.category,
                                theme: theme,
                              ),
                              _MetaChip(
                                icon: Icons.payments_outlined,
                                label: tender.budget.isEmpty
                                    ? 'Budget not set'
                                    : tender.budget,
                                theme: theme,
                              ),
                              _MetaChip(
                                icon: Icons.today_outlined,
                                label: tender.deadline.isEmpty
                                    ? 'No deadline'
                                    : tender.deadline,
                                theme: theme,
                              ),
                              _MetaChip(
                                icon: Icons.chat_bubble_outline,
                                label: '${tender.bidsCount} bids',
                                theme: theme,
                              ),
                            ],
                          ),
                        ],
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
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic theme;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
