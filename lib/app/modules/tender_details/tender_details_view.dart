import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
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
          const _StaticBackground(),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            }

            final data = controller.tenderDetails.value!;

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
                      Container(
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              title: "Deadline",
                              value: data.deadline,
                              icon: Icons.schedule,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _InfoCard(
                              title: "Status",
                              value: data.status.toUpperCase(),
                              icon: Icons.analytics_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.description,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Requirements",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...data.requirements.map(
                        (req) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  req,
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 15,
                                  ),
                                ),
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
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) return const SizedBox.shrink();

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.7),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Est. Budget",
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        controller.tenderDetails.value!.estimatedBudget,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        '/submit-bid',
                        arguments: controller.tenderDetails.value,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: colorScheme.primary.withOpacity(0.5),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Submit Bid",
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 16,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaticBackground extends StatelessWidget {
  const _StaticBackground();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.background,
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: _Glow(
              color: colorScheme.primary.withOpacity(0.2),
              size: 300,
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
