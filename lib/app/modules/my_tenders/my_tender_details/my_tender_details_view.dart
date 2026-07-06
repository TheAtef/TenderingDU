import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _InfoBlock(
                              title: data.category,
                              subtitle: data.status,
                              value:
                                  '${data.currency} ${data.budgetMin} - ${data.budgetMax}',
                            ),
                            const SizedBox(height: 16),
                            _SectionTitle('Description'),
                            const SizedBox(height: 8),
                            Text(
                              data.description,
                              style: TextStyle(
                                color: theme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _SectionTitle('Tender Info'),
                            const SizedBox(height: 8),
                            _DetailRow('Location', data.location),
                            _DetailRow('Start Date', data.startDate),
                            _DetailRow('Deadline', data.deadline),
                            const SizedBox(height: 20),
                            _SectionTitle('Bids'),
                            const SizedBox(height: 8),
                            if (data.bids.isEmpty)
                              Text(
                                'No bids on this tender yet.',
                                style: TextStyle(color: theme.textSecondary),
                              )
                            else
                              ...data.bids.map(
                                (bid) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(16),
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
                                            Expanded(
                                              child: Text(
                                                bid.companyName.isNotEmpty
                                                    ? bid.companyName
                                                    : bid.userName,
                                                style: TextStyle(
                                                  color: theme.textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              bid.statusName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          bid.proposal,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: theme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total Price: ${bid.totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: theme.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            _SectionTitle('Attachments'),
                            const SizedBox(height: 8),
                            if (data.attachments.isEmpty)
                              Text(
                                'No supporting documents available.',
                                style: TextStyle(color: theme.textSecondary),
                              )
                            else
                              ...data.attachments.map(
                                (attachment) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: theme.borderColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.description_outlined),
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
                                                    ? attachment.description
                                                    : 'Supporting Document',
                                                style: TextStyle(
                                                  color: theme.textPrimary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                attachment.formattedSize,
                                                style: TextStyle(
                                                  color: theme.textSecondary,
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
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
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
      padding: const EdgeInsets.only(bottom: 8),
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
            child: Text(value, style: TextStyle(color: theme.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;

  const _InfoBlock({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: theme.textSecondary)),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: theme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
