import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/validators.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _StaticBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 48),
                      Column(
                        children: [
                          const Icon(Icons.gavel_rounded, size: 75, color: AppColors.actionBlue),
                          const SizedBox(height: 16),
                          Text(
                            "TenderingDU",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: AppColors.actionBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(() => Text(
                                "Welcome Back",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeController.to.textPrimary,
                                ),
                              )),
                          const SizedBox(height: 6),
                          Obx(() => Text(
                                "Login to continue to your account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: ThemeController.to.textSecondary,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              _AuthTextField(
                                hintText: "Email or Syrian Mobile (e.g. 09x...)",
                                icon: Icons.person_outline_rounded,
                                controller: controller.identifierCtrl,
                                validator: Validators.emailOrSyrianMobile,
                              ),
                              const SizedBox(height: 20),
                              Obx(() => _AuthTextField(
                                    hintText: "Password",
                                    icon: Icons.lock_outline_rounded,
                                    controller: controller.passwordCtrl,
                                    isPassword: true,
                                    obscureText: controller.isPasswordHidden.value,
                                    onTogglePassword: controller.togglePasswordVisibility,
                                    validator: Validators.password,
                                  )),
                              const SizedBox(height: 32),
                              Obx(() => _AnimatedTap(
                                    child: ElevatedButton(
                                      onPressed: controller.isLoading.value ? null : controller.login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.actionBlue,
                                        minimumSize: const Size(double.infinity, 55),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 8,
                                        shadowColor: AppColors.actionBlue.withOpacity(0.5),
                                      ),
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                            )
                                          : const Text(
                                              "Login",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                    ),
                                  )),
                              const SizedBox(height: 24),
                              TextButton(
                                onPressed: controller.navigateToRegister,
                                child: Obx(() => RichText(
                                      text: TextSpan(
                                        text: "Don't have an account? ",
                                        style: TextStyle(color: ThemeController.to.textSecondary),
                                        children: const [
                                          TextSpan(
                                            text: "Sign Up",
                                            style: TextStyle(color: AppColors.actionBlue, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )),
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

class _StaticBackground extends StatelessWidget {
  const _StaticBackground();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -50, right: -50, child: _Glow(color: theme.glowBlue, size: 300)),
            Positioned(bottom: 100, left: -50, child: _Glow(color: theme.glowPurple, size: 250)),
          ],
        ),
      );
    });
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
          boxShadow: theme.isDarkMode ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: child),
        ),
      );
    });
  }
}

class _AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _AuthTextField({required this.hintText, required this.icon, this.isPassword = false, this.obscureText = false, this.onTogglePassword, this.controller, this.validator, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
          prefixIcon: Icon(icon, color: theme.textSecondary, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: theme.textSecondary, size: 20),
                  onPressed: onTogglePassword,
                )
              : null,
          filled: true,
          fillColor: theme.isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.actionBlue.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.actionBlue, width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.errorRed, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5)),
        ),
        validator: validator,
      );
    });
  }
}

class _AnimatedTap extends StatefulWidget {
  final Widget child;
  const _AnimatedTap({required this.child});
  @override
  State<_AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<_AnimatedTap> {
  double scale = 1;
  void _onTapDown(_) => setState(() => scale = 0.95);
  void _onTapUp(_) => setState(() => scale = 1);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown, onTapUp: _onTapUp, onTapCancel: () => setState(() => scale = 1),
      child: AnimatedScale(scale: scale, duration: const Duration(milliseconds: 120), child: widget.child),
    );
  }
}
