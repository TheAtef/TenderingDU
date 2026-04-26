import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/modules/profile/profile_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/validators.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ProfileController>(() => ProfileController());

    return CustomScrollView(
      controller: controller.scrollCtrl,
      physics: const BouncingScrollPhysics(),
      slivers: [
        _HeroHeader(controller: controller),
        _PersonalInfoCard(controller: controller),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final ProfileController controller;
  const _HeroHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => AnimatedTap(
                    child: _GlassIconButton(
                      icon: Icons.menu,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    AnimatedTap(
                      child: _GlassIconButton(
                        icon: Icons.edit_rounded,
                        onTap: () {
                          controller.populateEditFields();
                          Get.bottomSheet(
                            const EditProfileBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enterBottomSheetDuration: const Duration(
                              milliseconds: 400,
                            ),
                            exitBottomSheetDuration: const Duration(
                              milliseconds: 300,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.background,
                child: Text(
                  'JD',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${controller.profile.value?.firstName ?? ''} ${controller.profile.value?.lastName ?? ''}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: theme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      controller.profile.value?.isVerified == true
                          ? Icons.verified_rounded
                          : Icons.error_outline_rounded,
                      color: controller.profile.value?.isVerified == true
                          ? AppColors.actionBlue
                          : Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int? badge;
  const _GlassIconButton({required this.icon, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: theme.isDarkMode
              ? Theme.of(context).colorScheme.surface.withOpacity(0.3)
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme.textPrimary, size: 20),
      ),
    );
  }
}

class _PersonalInfoCard extends StatelessWidget {
  final ProfileController controller;
  const _PersonalInfoCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;
    final colorScheme = Theme.of(context).colorScheme;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Column(
              children: List.generate(3, (_) => const _ShimmerCard()),
            );
          }

          final profile = controller.profile.value;
          if (profile == null) {
            return Center(
              child: Text(
                'No profile data available.',
                style: TextStyle(color: theme.textPrimary),
              ),
            );
          }

          Widget buildCard({
            required String value1,
            required String label1,
            required String value2,
            required String label2,
          }) {
            return Container(
              height: 150,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
                    child: Text(
                      value1,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                    child: Text(
                      label1,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                    child: Text(
                      value2,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
                    child: Text(
                      label2,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  buildCard(
                    value1: profile.email,
                    label1: 'Email',
                    value2: profile.phone,
                    label2: 'Phone',
                  ),
                  buildCard(
                    value1: profile.birthdate,
                    label1: 'Birthdate',
                    value2: profile.sex,
                    label2: 'Sex',
                  ),
                  buildCard(
                    value1: profile.company,
                    label1: 'Company',
                    value2: profile.CRN,
                    label2: 'Commercial Register Number',
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class EditProfileBottomSheet extends GetView<ProfileController> {
  const EditProfileBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        height: Get.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: theme.backgroundColor.withOpacity(
            theme.isDarkMode ? 0.8 : 0.95,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          border: Border.all(color: theme.borderColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.actionBlue.withOpacity(0.1),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: theme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              "Edit Personal Info",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Form(
                key: controller.editFormKey,
                child: AnimationLimiter(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildModernTextField(
                                'First Name',
                                Icons.person_rounded,
                                controller.editFirstNameCtrl,
                                theme,
                                validator: (val) =>
                                    Validators.name(val, isLastName: false),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildModernTextField(
                                'Last Name',
                                Icons.person_rounded,
                                controller.editLastNameCtrl,
                                theme,
                                validator: (val) =>
                                    Validators.name(val, isLastName: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          'Email Address',
                          Icons.email_rounded,
                          controller.editEmailCtrl,
                          theme,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 16),
                        _buildModernTextField(
                          'Syrian Phone Number',
                          Icons.phone_rounded,
                          controller.editPhoneCtrl,
                          theme,
                          keyboardType: TextInputType.phone,
                          validator: Validators.syrianMobile,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildModernTextField(
                                'Birthdate (YYYY-MM-DD)',
                                Icons.calendar_month_rounded,
                                controller.editBirthdateCtrl,
                                theme,
                                validator: Validators.birthdate,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildModernDropdown(
                                'Sex',
                                Icons.wc_rounded,
                                controller.editSexCtrl,
                                theme,
                                ['Male', 'Female'],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => _buildModernTextField(
                            'Enter Password to Confirm Edit',
                            Icons.lock_rounded,
                            controller.editPasswordCtrl,
                            theme,
                            obscureText: controller.isPasswordHidden.value,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Password is required to apply changes';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: theme.textSecondary,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ), // extra padding for scrolling
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: theme.borderColor),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: controller.saveProfileChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField(
    String label,
    IconData icon,
    TextEditingController txtController,
    ThemeController theme, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderColor.withOpacity(0.5)),
      ),
      child: TextFormField(
        controller: txtController,
        style: TextStyle(color: theme.textPrimary),
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.actionBlue.withOpacity(0.7)),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          errorStyle: const TextStyle(height: 0),
        ),
      ),
    );
  }

  Widget _buildModernDropdown(
    String label,
    IconData icon,
    TextEditingController txtController,
    ThemeController theme,
    List<String> items,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.borderColor.withOpacity(0.5)),
      ),
      child: DropdownButtonFormField<String>(
        value:
            txtController.text.isNotEmpty && items.contains(txtController.text)
            ? txtController.text
            : null,
        dropdownColor: theme.cardColor,
        style: TextStyle(color: theme.textPrimary, fontSize: 16),
        icon: Icon(Icons.arrow_drop_down_rounded, color: theme.textSecondary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.actionBlue.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          errorStyle: const TextStyle(height: 0),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) {
          if (val != null) txtController.text = val;
        },
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }
}
