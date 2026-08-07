import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

import 'my_tender_details_controller.dart';

class MyTenderDetailsView extends GetView<MyTenderDetailsController> {
  const MyTenderDetailsView({super.key});

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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.isError.value) {
                    return Center(
                      child: Text(
                        'Failed to load tender details.',
                        style: TextStyle(color: theme.textSecondary),
                      ),
                    );
                  }

                  final data = controller.tenderDetails;
                  final bidsCount = data.bids.length;
                  final attachmentsCount = data.attachments.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedTap(
                            child: GlassIconButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Get.back(),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              data.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: theme.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 8),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _HeroCard(
                              category: data.category,
                              status: data.status,
                              title: data.title,
                              budget:
                                  '${data.currency} ${data.budgetMin} - ${data.budgetMax}',
                              bidsCount: bidsCount,
                              attachmentsCount: attachmentsCount,
                            ),
                            const SizedBox(height: 16),
                            _SectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionTitle('Description'),
                                  const SizedBox(height: 10),
                                  Text(
                                    data.description,
                                    style: TextStyle(
                                      color: theme.textSecondary,
                                      height: 1.55,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _SectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionTitle('Tender Info'),
                                  const SizedBox(height: 14),
                                  _DetailRow('Location', data.location),
                                  _DetailRow('Start Date', data.startDate),
                                  _DetailRow('Deadline', data.deadline),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _SectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionTitle('Bids'),
                                  const SizedBox(height: 10),
                                  if (data.bids.isEmpty)
                                    Text(
                                      'No bids on this tender yet.',
                                      style: TextStyle(
                                        color: theme.textSecondary,
                                      ),
                                    )
                                  else
                                    ...data.bids.map(
                                      (bid) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: GestureDetector(
                                          onTap: () => Get.toNamed(
                                            Routes.BID_DETAILS,
                                            arguments: bid,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: theme.backgroundColor
                                                  .withOpacity(0.55),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color: theme.borderColor,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 42,
                                                      height: 42,
                                                      decoration: BoxDecoration(
                                                        color: theme.textPrimary
                                                            .withOpacity(0.06),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        Icons.business_outlined,
                                                        color:
                                                            theme.textSecondary,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            bid
                                                                    .companyName
                                                                    .isNotEmpty
                                                                ? bid.companyName
                                                                : bid.userName,
                                                            style: TextStyle(
                                                              color: theme
                                                                  .textPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            bid
                                                                    .tenderOwner
                                                                    .isNotEmpty
                                                                ? 'By ${bid.userName}'
                                                                : bid.userName,
                                                            style: TextStyle(
                                                              color: theme
                                                                  .textSecondary,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: _statusColor(
                                                          bid.statusName,
                                                        ).withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              999,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        bid.statusName,
                                                        style: TextStyle(
                                                          color: _statusColor(
                                                            bid.statusName,
                                                          ),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  bid.proposal,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: theme.textSecondary,
                                                    height: 1.45,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _Pill(
                                                      icon: Icons
                                                          .payments_outlined,
                                                      label: bid.totalPrice
                                                          .toStringAsFixed(2),
                                                    ),
                                                    _Pill(
                                                      icon: Icons.schedule,
                                                      label:
                                                          bid.estimatedDuration,
                                                    ),
                                                    _Pill(
                                                      icon: Icons
                                                          .work_outline_rounded,
                                                      label:
                                                          bid
                                                              .companyName
                                                              .isNotEmpty
                                                          ? bid.companyName
                                                          : 'Individual bid',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _SectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionTitle('Attachments'),
                                  const SizedBox(height: 10),
                                  if (data.attachments.isEmpty)
                                    Text(
                                      'No supporting documents available.',
                                      style: TextStyle(
                                        color: theme.textSecondary,
                                      ),
                                    )
                                  else
                                    ...data.attachments.map(
                                      (attachment) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: theme.backgroundColor
                                                .withOpacity(0.55),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: theme.borderColor,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 42,
                                                height: 42,
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                    0.08,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.red,
                                                  size: 22,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      attachment
                                                              .description
                                                              .isNotEmpty
                                                          ? attachment
                                                                .description
                                                          : 'Supporting Document',
                                                      style: TextStyle(
                                                        color:
                                                            theme.textPrimary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      attachment.formattedSize,
                                                      style: TextStyle(
                                                        color:
                                                            theme.textSecondary,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: ThemeController.to.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.borderColor),
      ),
      child: child,
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String category;
  final String status;
  final String title;
  final String budget;
  final int bidsCount;
  final int attachmentsCount;

  const _HeroCard({
    required this.category,
    required this.status,
    required this.title,
    required this.budget,
    required this.bidsCount,
    required this.attachmentsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    final statusColor = _statusColor(status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ThemeController.to.backgroundColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: theme.borderColor),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusColor.withOpacity(0.18)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            budget,
            style: TextStyle(
              color: theme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Bids',
                  value: bidsCount.toString(),
                  icon: Icons.chat_bubble_outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'Files',
                  value: attachmentsCount.toString(),
                  icon: Icons.attach_file,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.actionBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.actionBlue, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
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
        ],
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'open':
      return const Color(0xFF1E88E5);
    case 'closed':
      return const Color(0xFF546E7A);
    default:
      return const Color(0xFFE65100);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: theme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: theme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
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
