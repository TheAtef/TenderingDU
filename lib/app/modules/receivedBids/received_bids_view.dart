import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
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
          CustomScrollView(slivers: [_buildHeader(theme), _buildList(theme)]),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic theme) {
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

  Widget _buildList(dynamic theme) {
    return Obx(
      () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final bid = controller.bidsList[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () => controller.goToDetails(bid),
                  child: _SummaryCard(bid: bid, theme: theme),
                ),
              ),
            );
          }, childCount: controller.bidsList.length),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> bid;
  final dynamic theme;
  const _SummaryCard({required this.bid, required this.theme});

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
                  bid['bidder'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${bid['amount']}",
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
