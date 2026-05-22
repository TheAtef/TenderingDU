import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'tender_details_controller.dart';

class TenderDetailsView extends GetView<TenderDetailsController> {
  const TenderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavourite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavourite.value
                    ? colorScheme.error
                    : colorScheme.onSurface,
              ),
              onPressed: controller.toggleFavourite,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const StaticBackground(),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            }

            if (controller.isError.value) {
              return const Center(child: Text("Error loading data"));
            }

            final data = controller.tenderDetails;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 120),
              physics: const BouncingScrollPhysics(),
              child: AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                data.category,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _StatusChip(status: data.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.0,
                        children: [
                          _InfoCard(
                            title: "Location",
                            value: data.location,
                            icon: Icons.location_on_outlined,
                          ),
                          _InfoCard(
                            title: "Budget (${data.currency})",
                            value: "${data.budgetMin} - ${data.budgetMax}",
                            icon: Icons.payments_outlined,
                          ),
                          _InfoCard(
                            title: "Start Date",
                            value: data.startDate,
                            icon: Icons.calendar_today_rounded,
                          ),
                          _InfoCard(
                            title: "Deadline",
                            value: data.deadline,
                            icon: Icons.timer_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.description,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Requirements",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...data.requirements.map(
                        (req) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: colorScheme.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  req,
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Attachments",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (data.attachments.isEmpty)
                        Text(
                          "No supporting documents available.",
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        )
                      else
                        ...data.attachments.map(
                          (attachment) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _DocumentAttachment(
                              title: attachment.description.isNotEmpty
                                  ? attachment.description
                                  : "Supporting Document",
                              subtitle:
                                  "Tap to view (${attachment.formattedSize})",
                              onTap: () => Get.toNamed(
                                '/pdf-viewer',
                                arguments: {
                                  'url': attachment.fileUrl,
                                  'title': attachment.description.isNotEmpty
                                      ? attachment.description
                                      : data.title,
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.isError.value) {
          return const SizedBox.shrink();
        }

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.7),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Est. Budget (${controller.tenderDetails.currency})",
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${controller.tenderDetails.budgetMin} - ${controller.tenderDetails.budgetMax}",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: controller.submitBid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Submit Bid",
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DocumentAttachment extends StatelessWidget {
  final String title;
  final String subtitle; // Added subtitle parameter
  final VoidCallback onTap;

  const _DocumentAttachment({
    required this.title,
    required this.subtitle, // Added to constructor
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle, // Display dynamic subtitle/size
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colorScheme.primary, size: 18),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'open':
        color = Colors.green;
        break;
      case 'closed':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
