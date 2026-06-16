import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildTextField(
                        "Current Password",
                        controller.oldPasswordController,
                      ),
                      // Professional Forgot Password placement
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: controller.goToForgotPassword,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(top: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "forgot_password".tr,
                            style: TextStyle(
                              color: AppColors.actionBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "New Password",
                        controller.newPasswordController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "Confirm New Password",
                        controller.confirmPasswordController,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save Changes",
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
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl) {
    final theme = ThemeController.to;
    return Obx(() {
      final isObscure = controller.obscureMap[label] ?? true;
      return TextFormField(
        controller: ctrl,
        obscureText: isObscure,
        style: TextStyle(color: theme.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.borderColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.actionBlue),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: theme.textSecondary,
            ),
            onPressed: () => controller.toggleObscure(label),
          ),
        ),
        validator: (val) => val!.isEmpty ? "Required field" : null,
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
          borderRadius: BorderRadius.circular(20),
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
        child: child,
      );
    });
  }
}
