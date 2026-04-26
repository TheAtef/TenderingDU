import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StaticBackground(),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: TextButton(
                      onPressed: controller.skip,
                      child: Obx(
                        () => Text(
                          "Skip",
                          style: TextStyle(
                            color: ThemeController.to.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      return _OnboardingPage(item: controller.items[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      _AnimatedDots(controller: controller),
                      const SizedBox(height: 32),
                      _NextButton(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  const _OnboardingPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container with Glow
            SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.actionBlue.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    size: 100,
                    color: AppColors.actionBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ThemeController.to.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: ThemeController.to.textSecondary,
                              height: 1.5,
                            ),
                          ),
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
    );
  }
}

class _AnimatedDots extends StatelessWidget {
  final OnboardingController controller;
  const _AnimatedDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.items.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: controller.currentIndex.value == index ? 24 : 8,
            decoration: BoxDecoration(
              color: controller.currentIndex.value == index
                  ? AppColors.actionBlue
                  : ThemeController.to.isDarkMode
                  ? Colors.white24
                  : Colors.black12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    });
  }
}

class _NextButton extends StatelessWidget {
  final OnboardingController controller;
  const _NextButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLast =
          controller.currentIndex.value == controller.items.length - 1;
      return AnimatedTap(
        child: ElevatedButton(
          onPressed: controller.nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.actionBlue,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: AppColors.actionBlue.withOpacity(0.5),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isLast ? "Get Started" : "Continue",
              key: ValueKey<bool>(isLast),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(32),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: child,
          ),
        ),
      );
    });
  }
}
