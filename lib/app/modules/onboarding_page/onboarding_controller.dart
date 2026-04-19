import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/routes/app_routes.dart';

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentIndex = 0.obs;

  final items = [
    OnboardingItem(
      title: "Discover Tenders",
      description:
          "Find the best business opportunities matching your company profile and expertise effortlessly.",
      icon: Icons.search_rounded,
    ),
    OnboardingItem(
      title: "Apply with Ease",
      description:
          "Submit your bids seamlessly through our secure and streamlined platform.",
      icon: Icons.send_rounded,
    ),
    OnboardingItem(
      title: "Track Your Bids",
      description:
          "Monitor your applications, receive real-time notifications, and win more contracts.",
      icon: Icons.analytics_outlined,
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
