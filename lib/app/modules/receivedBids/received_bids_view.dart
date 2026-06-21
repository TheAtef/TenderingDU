import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'package:tendering_du/app/modules/my_bids/bid_model.dart';
import 'package:tendering_du/app/modules/receivedBids/received_bids_controller.dart';

class ReceivedBidsView extends GetView<ReceivedBidsController> {
  const ReceivedBidsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          const StaticBackground(),
          ResponsiveLayout(
            mobile: _buildMobileLayout(theme),
            desktop: _buildDesktopLayout(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(ThemeController theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [_buildMobileHeader(theme), _buildMobileList(theme)],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(ThemeController theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassIconButton(icon: Icons.arrow_back, onTap: () => Get.back()),
            const SizedBox(height: 30),
            Text(
              "Incoming Bids".tr,
              style: TextStyle(fontSize: 16, color: theme.textSecondary),
            ),
            Text(
              "Manage Offers".tr,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(ThemeController theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      if (controller.bidsList.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                "No bids received yet.".tr,
                style: TextStyle(color: theme.textSecondary),
              ),
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final bid = controller.bidsList[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 300),
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () => controller.goToDetails(bid),
                  child: _MobileSummaryCard(bid: bid, theme: theme),
                ),
              ),
            );
          }, childCount: controller.bidsList.length),
        ),
      );
    });
  }

  Widget _buildDesktopLayout(ThemeController theme) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manage Offers".tr,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Incoming Bids".tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: theme.textPrimary,
                      size: 18,
                    ),
                    label: Text(
                      "Filter",
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
                            Expanded(flex: 2, child: _TableHead("Applicant")),
                            Expanded(
                              flex: 3,
                              child: _TableHead("Tender Reference"),
                            ),
                            Expanded(flex: 1, child: _TableHead("Bid Amount")),
                            Expanded(
                              flex: 1,
                              child: _TableHead("Actions", alignRight: true),
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

                          if (controller.bidsList.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inbox_rounded,
                                    size: 64,
                                    color: theme.textSecondary.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No bids received yet.".tr,
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
                            itemCount: controller.bidsList.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1, color: theme.borderColor),
                            itemBuilder: (context, index) {
                              final bid = controller.bidsList[index];
                              return _DesktopTableRow(
                                bid: bid,
                                controller: controller,
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
  final BidModel bid;
  final ReceivedBidsController controller;
  final ThemeController theme;

  const _DesktopTableRow({
    required this.bid,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final applicantName = bid.companyName.isNotEmpty
        ? bid.companyName
        : bid.userName;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.goToDetails(bid),
        hoverColor: AppColors.actionBlue.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.actionBlue.withOpacity(0.1),
                      child: Text(
                        applicantName.isNotEmpty
                            ? applicantName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppColors.actionBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        applicantName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 3,
                child: Text(
                  bid.tenderTitle,
                  style: TextStyle(fontSize: 15, color: theme.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "\$${bid.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => controller.goToDetails(bid),
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
                      "View Details",
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

class _MobileSummaryCard extends StatelessWidget {
  final BidModel bid;
  final ThemeController theme;

  const _MobileSummaryCard({required this.bid, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bid.companyName.isNotEmpty ? bid.companyName : bid.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bid.tenderTitle,
                  style: TextStyle(fontSize: 13, color: theme.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${bid.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
