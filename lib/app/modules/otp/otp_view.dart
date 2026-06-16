import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/modules/otp/otp_conroller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StaticBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              color: AppColors.actionBlue,
                              onPressed: () => Get.back(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: [
                              const Icon(
                                Icons.key_outlined,
                                size: 75,
                                color: AppColors.actionBlue,
                              ),
                              const SizedBox(height: 16),
                              Obx(
                                () => Text(
                                  "OTP Verification",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                    color: ThemeController.to.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Obx(
                                () => Text(
                                  "Enter the six-digit code sent to your email to prove your ownership.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeController.to.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                          _GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  _AuthTextField(
                                    hintText: "Six-Digits code (eg. 123456)",
                                    icon: Icons.person_outline_rounded,
                                    controller: controller.otpCtrl,

                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'otp_required'.tr;
                                      }
                                      if (value.trim().length != 6) {
                                        return 'otp_length'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        controller.ctrlSendOtp();
                                      },
                                      child: Text(
                                        "Resend OTP",
                                        style: TextStyle(
                                          color: AppColors.actionBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => _AnimatedTap(
                                      child: ElevatedButton(
                                        onPressed: controller.isLoading.value
                                            ? null
                                            : controller.submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.actionBlue,
                                          minimumSize: const Size(
                                            double.infinity,
                                            55,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: AppColors.actionBlue
                                              .withOpacity(0.5),
                                        ),
                                        child: controller.isLoading.value
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : const Text(
                                                "Verify",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: child,
          ),
        ),
      );
    });
  }
}

class _AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.hintText,
    required this.icon,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.number,
        style: TextStyle(color: theme.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textSecondary.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: theme.textSecondary, size: 22),
          filled: true,
          fillColor: theme.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : AppColors.actionBlue.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.borderColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.actionBlue,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
      );
    });
  }
}

class _AnimatedTap extends StatefulWidget {
  final Widget child;
  const _AnimatedTap({required this.child});
  @override
  __AnimatedTapState createState() => __AnimatedTapState();
}

class __AnimatedTapState extends State<_AnimatedTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
