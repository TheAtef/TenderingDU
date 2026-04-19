import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/validators.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Obx(() => IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ThemeController.to.textPrimary),
          onPressed: () => Get.back(),
        )),
      ),
      body: Stack(
        children: [
          const _StaticBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.person_add_alt_1_rounded, size: 60, color: AppColors.actionBlue),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                          "Create Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: ThemeController.to.textPrimary,
                          ),
                        )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          "Join TenderingDU today",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: ThemeController.to.textSecondary,
                          ),
                        )),
                    const SizedBox(height: 32),
                    _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle("Personal Details"),
                            Row(
                              children: [
                                Expanded(child: _AuthTextField(hintText: "First Name", icon: Icons.person_outline_rounded, controller: controller.fNameCtrl, validator: Validators.name, textCapitalization: TextCapitalization.words)),
                                const SizedBox(width: 16),
                                Expanded(child: _AuthTextField(hintText: "Last Name", icon: Icons.person_outline_rounded, controller: controller.lNameCtrl, validator: Validators.name, textCapitalization: TextCapitalization.words)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _AuthTextField(hintText: "Email Address", icon: Icons.email_outlined, controller: controller.emailCtrl, validator: Validators.email, keyboardType: TextInputType.emailAddress),
                            const SizedBox(height: 16),
                            _AuthTextField(hintText: "Syrian Mobile (09x / +9639x)", icon: Icons.phone_android_rounded, controller: controller.mobileCtrl, validator: Validators.syrianMobile, keyboardType: TextInputType.phone),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _AuthTextField(hintText: "Age", icon: Icons.calendar_today_rounded, controller: controller.ageCtrl, validator: Validators.age, keyboardType: TextInputType.number)),
                                const SizedBox(width: 16),
                                Expanded(child: Obx(() => _AuthDropdown(hintText: "Gender", icon: Icons.people_outline_rounded, value: controller.selectedGender.value, items: controller.genders, onChanged: controller.setGender))),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _SectionTitle("Business Details"),
                            _AuthTextField(hintText: "Company Name", icon: Icons.business_rounded, controller: controller.companyCtrl, validator: Validators.required),
                            const SizedBox(height: 16),
                            _AuthTextField(hintText: "Commercial Registration Number", icon: Icons.numbers_rounded, controller: controller.crnCtrl, validator: Validators.required, keyboardType: TextInputType.number),
                            const SizedBox(height: 16),
                            Obx(() => _AuthDropdown(hintText: "Business Activity", icon: Icons.work_outline_rounded, value: controller.selectedActivity.value, items: controller.activities, onChanged: controller.setActivity)),
                            const SizedBox(height: 24),
                            _SectionTitle("Security"),
                            Obx(() => _AuthTextField(
                                  hintText: "Password",
                                  icon: Icons.lock_outline_rounded,
                                  controller: controller.passwordCtrl,
                                  isPassword: true,
                                  obscureText: controller.isPasswordHidden.value,
                                  onTogglePassword: controller.togglePasswordVisibility,
                                  validator: Validators.password,
                                )),
                            const SizedBox(height: 16),
                            Obx(() => _AuthTextField(
                                  hintText: "Confirm Password",
                                  icon: Icons.lock_reset_rounded,
                                  controller: controller.confirmPasswordCtrl,
                                  isPassword: true,
                                  obscureText: controller.isConfirmPasswordHidden.value,
                                  onTogglePassword: controller.toggleConfirmPasswordVisibility,
                                  validator: (v) => Validators.confirmPassword(v, controller.passwordCtrl.text),
                                )),
                            const SizedBox(height: 32),
                            Obx(() {
                              bool isBusy = controller.isLoading.value || controller.isSuccess.value;
                              return Center(
                                child: _AnimatedTap(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    height: 55,
                                    width: isBusy ? 55 : MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: controller.isSuccess.value ? Colors.green : AppColors.actionBlue,
                                      borderRadius: BorderRadius.circular(isBusy ? 30 : 16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (controller.isSuccess.value ? Colors.green : AppColors.actionBlue).withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: isBusy ? null : controller.register,
                                        borderRadius: BorderRadius.circular(isBusy ? 30 : 16),
                                        child: Center(
                                          child: controller.isSuccess.value
                                              ? const Icon(Icons.check_rounded, color: Colors.white, size: 30)
                                              : controller.isLoading.value
                                                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                                  : const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                            Center(
                              child: TextButton(
                                onPressed: controller.navigateToLogin,
                                child: Obx(() => RichText(
                                      text: TextSpan(
                                        text: "Already have an account? ",
                                        style: TextStyle(color: ThemeController.to.textSecondary),
                                        children: const [
                                          TextSpan(text: "Login", style: TextStyle(color: AppColors.actionBlue, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )),
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
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: ThemeController.to.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}

class _AuthDropdown extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _AuthDropdown({required this.hintText, required this.icon, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return DropdownButtonFormField<String>(
        value: value,
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.textSecondary),
        dropdownColor: theme.cardColor,
        style: TextStyle(color: theme.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: theme.textSecondary, size: 20),
          filled: true,
          fillColor: theme.isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.actionBlue.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: theme.isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.actionBlue, width: 1.5)),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Required' : null,
      );
    });
  }
}

// Below are exact copies from the login view to ensure independence without a shared widgets file
class _StaticBackground extends StatelessWidget {
  const _StaticBackground();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: ThemeController.to.gradientColors)),
        child: Stack(
          children: [
            Positioned(top: -50, right: -50, child: _Glow(color: ThemeController.to.glowBlue, size: 300)),
            Positioned(bottom: 100, left: -50, child: _Glow(color: ThemeController.to.glowPurple, size: 250)),
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
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)]));
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
          color: theme.cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.borderColor),
          boxShadow: theme.isDarkMode ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(24), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: child)),
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
  final TextCapitalization textCapitalization;

  const _AuthTextField({required this.hintText, required this.icon, this.isPassword = false, this.obscureText = false, this.onTogglePassword, this.controller, this.validator, this.keyboardType, this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return TextFormField(
        controller: controller, obscureText: obscureText, keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: TextStyle(color: theme.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: theme.textSecondary, size: 20),
          suffixIcon: isPassword ? IconButton(icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: theme.textSecondary, size: 18), onPressed: onTogglePassword) : null,
          filled: true, fillColor: theme.isDarkMode ? Colors.white.withOpacity(0.05) : AppColors.actionBlue.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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
