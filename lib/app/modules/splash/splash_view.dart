import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Adjust these imports to match your project name/paths
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/modules/splash/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.gavel_rounded,
                    size: 80,
                    color: AppColors.actionBlue,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "TenderingDU",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Smart Bidding Solutions",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.greyBlue,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.actionBlue),
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
