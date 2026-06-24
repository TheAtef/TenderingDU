import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/modules/bidsDetails/bidDetails_controller.dart';

class BidDetailsView extends GetView<BidDetailsController> {
  const BidDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          const StaticBackground(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Stack(
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        _buildHeader(theme),
                        _buildMainInfo(theme),
                        _buildExtendedInfo(theme),
                        _buildAttachmentsSection(theme),
                        const SliverToBoxAdapter(child: SizedBox(height: 120)),
                      ],
                    );
                  }),
                  Obx(() {
                    if (!controller.isLoading.value &&
                        controller.canPerformActions) {
                      return _buildActionButtons(theme);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 10),
        child: Row(
          children: [
            GlassIconButton(icon: Icons.arrow_back, onTap: () => Get.back()),
            const SizedBox(width: 20),
            Text(
              "Bid Details".tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo(dynamic theme) {
    final data = controller.bid;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.companyName.isNotEmpty ? data.companyName : data.userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Submitted for: ${data.tenderTitle}",
              style: TextStyle(fontSize: 14, color: theme.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "\$${data.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data.statusName,
                    style: const TextStyle(
                      color: AppColors.actionBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Main Proposal", theme),
            const SizedBox(height: 8),
            Text(
              data.proposal,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: theme.borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildExtendedInfo(dynamic theme) {
    final data = controller.bid;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Technical Details", theme),
            const SizedBox(height: 16),
            _buildDetailCard(
              "Execution Plan / Methodology",
              data.executionPlan,
              theme,
            ),
            _buildDetailCard("Deliverables", data.deliverables, theme),
            _buildDetailCard(
              "Estimated Duration",
              data.estimatedDuration,
              theme,
            ),

            const SizedBox(height: 16),
            Divider(color: theme.borderColor),
            const SizedBox(height: 16),

            _buildSectionTitle("Bidder Information", theme),
            const SizedBox(height: 16),
            _buildContactRow(
              Icons.person,
              "Contact Person",
              data.contactPerson,
              theme,
            ),
            _buildContactRow(Icons.email, "Email", data.contactEmail, theme),
            _buildContactRow(Icons.phone, "Phone", data.contactPhone, theme),

            const SizedBox(height: 24),
            Divider(color: theme.borderColor),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(dynamic theme) {
    final files = controller.bid.documents;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Supporting Documents", theme),
            const SizedBox(height: 16),
            if (files.isEmpty)
              Text(
                "No documents attached.",
                style: TextStyle(color: theme.textSecondary, fontSize: 14),
              )
            else
              ...files.map((doc) {
                final fileName = doc.description.isNotEmpty
                    ? doc.description
                    : "Bid Document ${doc.id}";
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: theme.borderColor),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      fileName,
                      style: TextStyle(color: theme.textPrimary, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () =>
                        controller.viewAttachment(doc.fileUrl, fileName),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(dynamic theme) {
    return Positioned(
      bottom: 30,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: theme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _Button(
                label: "Reject",
                color: Colors.redAccent,
                onTap: () =>
                    controller.handleBidAction(controller.bid.id, "reject"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Button(
                label: "Accept",
                color: AppColors.actionBlue,
                isPrimary: true,
                onTap: () =>
                    controller.handleBidAction(controller.bid.id, "accept"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, dynamic theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.textPrimary,
      ),
    );
  }

  Widget _buildDetailCard(String title, String content, dynamic theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.borderColor),
            ),
            child: Text(
              content.isNotEmpty ? content : "Not specified",
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String title,
    String value,
    dynamic theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.actionBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.actionBlue, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: theme.textSecondary),
              ),
              Text(
                value.isNotEmpty ? value : "Not specified",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final Color color;
  final bool isPrimary;
  final VoidCallback onTap;
  const _Button({
    required this.label,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isPrimary ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
