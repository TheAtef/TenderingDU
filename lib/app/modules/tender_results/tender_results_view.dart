import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'package:tendering_du/app/modules/tender_details/tender_details_model.dart';
import 'tender_results_controller.dart';

class TenderResultsView extends GetView<TenderResultsController> {
  const TenderResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "tenders_results".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tenders.isEmpty) {
          return Center(child: Text("no_tenders_available".tr));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.tenders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _TenderCard(item: controller.tenders[index]),
        );
      }),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final theme = ThemeController.to;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          // const StaticBackground(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
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
                          "tenders_results".tr,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: theme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: theme.textPrimary,
                            size: 18,
                          ),
                          label: Text(
                            "Refresh",
                            style: TextStyle(color: theme.textPrimary),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            side: BorderSide(color: theme.borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: Container(
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: theme.borderColor),
                                ),
                                color: theme.isDarkMode
                                    ? Colors.white.withOpacity(0.02)
                                    : Colors.black.withOpacity(0.02),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _TableHead("Tender Details"),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _TableHead("category".tr),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _TableHead("budget".tr),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _TableHead("deadline".tr),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _TableHead("Status"),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _TableHead(
                                      "Actions",
                                      alignRight: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Obx(() {
                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (controller.tenders.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.folder_off_rounded,
                                          size: 64,
                                          color: theme.textSecondary
                                              .withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "no_tenders_available".tr,
                                          style: TextStyle(
                                            color: theme.textSecondary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: controller.tenders.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    color: theme.borderColor,
                                  ),
                                  itemBuilder: (context, index) {
                                    final item = controller.tenders[index];
                                    return _DesktopTableRow(
                                      item: item,
                                      theme: theme,
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  final String title;
  final bool alignRight;
  const _TableHead(this.title, {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: ThemeController.to.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _DesktopTableRow extends StatelessWidget {
  final TenderDetailsModel item;
  final ThemeController theme;

  const _DesktopTableRow({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed('/tender-details', arguments: item),
        hoverColor: AppColors.actionBlue.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: theme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  item.category,
                  style: TextStyle(fontSize: 14, color: theme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${item.budgetMin} - ${item.budgetMax} ${item.currency}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  item.deadline,
                  style: TextStyle(fontSize: 14, color: theme.textSecondary),
                ),
              ),

              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _StatusBadge(status: item.status),
                ),
              ),

              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Get.toNamed('/tender-details', arguments: item),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.actionBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
}

class _TenderCard extends StatelessWidget {
  final TenderDetailsModel item;
  const _TenderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/tender-details', arguments: item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.grid_view_rounded,
              label: "category".tr,
              value: item.category,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: "location".tr,
              value: item.location,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.attach_money_rounded,
              label: "budget".tr,
              value: "${item.budgetMin} - ${item.budgetMax} ${item.currency}",
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.event_available_rounded,
              label: "deadline".tr,
              value: item.deadline,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'awarded':
      case 'closed':
        color = Colors.red;
        break;
      case 'pending':
      case 'open':
        color = Colors.green;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
