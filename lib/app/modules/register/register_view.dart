import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/validators.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
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
        leading: Obx(
          () => IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ThemeController.to.textPrimary,
            ),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Stack(
        children: [
          const _StaticBackground(),
          SafeArea(child: _WizardForm(controller: controller)),
        ],
      ),
    );
  }
}

class _WizardStep extends StatefulWidget {
  final Widget child;
  const _WizardStep({required this.child});
  @override
  State<_WizardStep> createState() => _WizardStepState();
}

class _WizardStepState extends State<_WizardStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _WizardForm extends StatefulWidget {
  final RegisterController controller;
  const _WizardForm({required this.controller});

  @override
  State<_WizardForm> createState() => _WizardFormState();
}

class _WizardFormState extends State<_WizardForm> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final GlobalKey<FormState> _step1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _step3Key = GlobalKey<FormState>();

  void _nextPage() {
    FocusScope.of(context).unfocus();

    // Validation logic per step
    if (_currentPage == 0) {
      if (!_step1Key.currentState!.validate()) return;
      if (widget.controller.selectedSex.value == null) {
        Get.snackbar(
          'error'.tr,
          'select_sex'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    } else if (_currentPage == 1) {
      if (!_step2Key.currentState!.validate()) return;
      if (widget.controller.selectedActivity.value == null) {
        Get.snackbar(
          'error'.tr,
          'select_activity'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    FocusScope.of(context).unfocus();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Icon(
          Icons.person_add_alt_1_rounded,
          size: 50,
          color: AppColors.actionBlue,
        ),
        const SizedBox(height: 12),
        Obx(
          () => Text(
            "create_acc".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ThemeController.to.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _currentPage == 0
              ? "step_1".tr
              : _currentPage == 1
              ? "step_2".tr
              : "step_3".tr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.actionBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              _WizardStep(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _step1Key,
                    child: _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle("personal_details".tr),
                            Row(
                              children: [
                                Expanded(
                                  child: _AuthTextField(
                                    hintText: "first_name".tr,
                                    icon: Icons.person_outline_rounded,
                                    controller: widget.controller.fNameCtrl,
                                    validator: Validators.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _AuthTextField(
                                    hintText: "last_name".tr,
                                    icon: Icons.person_outline_rounded,
                                    controller: widget.controller.lNameCtrl,
                                    validator: Validators.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _AuthTextField(
                              hintText: "email_address".tr,
                              icon: Icons.email_outlined,
                              controller: widget.controller.emailCtrl,
                              validator: Validators.email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            _AuthTextField(
                              hintText: "phone".tr,
                              icon: Icons.phone_android_rounded,
                              controller: widget.controller.mobileCtrl,
                              validator: Validators.syrianMobile,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _AuthTextField(
                                    hintText: "birth".tr,
                                    icon: Icons.calendar_month_rounded,
                                    controller: widget.controller.birthdateCtrl,
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty)
                                        return 'req'.tr;
                                      if (!RegExp(
                                        r"^\d{4}-\d{2}-\d{2}$",
                                      ).hasMatch(val.trim()))
                                        return 'birth_format'.tr;
                                      final parsedDate = DateTime.tryParse(
                                        val.trim(),
                                      );
                                      if (parsedDate == null)
                                        return 'invalid_date'.tr;
                                      if (parsedDate.isAfter(DateTime.now()))
                                        return 'future_date'.tr;
                                      return null;
                                    },
                                    keyboardType: TextInputType.datetime,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Obx(
                                    () => _AuthDropdown(
                                      hintText: "sex".tr,
                                      icon: Icons.wc_rounded,
                                      value:
                                          widget.controller.selectedSex.value,
                                      items: widget.controller.sexOptions,
                                      onChanged: widget.controller.setSex,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _NavigationButton(
                              title: "next".tr,
                              onPressed: _nextPage,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // Closes Form
                ), // Closes SingleChildScrollView
              ), // Closes _WizardStep
              _WizardStep(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _step2Key,
                    child: _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle("business_details".tr),
                            _AuthTextField(
                              hintText: "company_name".tr,
                              icon: Icons.business_rounded,
                              controller: widget.controller.companyCtrl,
                              validator: Validators.required,
                            ),
                            const SizedBox(height: 16),
                            _AuthTextField(
                              hintText: "crn".tr,
                              icon: Icons.numbers_rounded,
                              controller: widget.controller.crnCtrl,
                              validator: Validators.required,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => _AuthDropdown(
                                hintText: "business_activity".tr,
                                icon: Icons.work_outline_rounded,
                                value: widget.controller.selectedActivity.value,
                                items: widget.controller.activities,
                                onChanged: widget.controller.setActivity,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: _NavigationButton(
                                    title: "back".tr,
                                    isOutline: true,
                                    onPressed: _prevPage,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _NavigationButton(
                                    title: "next".tr,
                                    onPressed: _nextPage,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // Closes Form
                ), // Closes SingleChildScrollView
              ), // Closes _WizardStep
              _WizardStep(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _step3Key,
                    child: _GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionTitle("security".tr),
                            Obx(
                              () => _AuthTextField(
                                hintText: "password".tr,
                                icon: Icons.lock_outline_rounded,
                                controller: widget.controller.passwordCtrl,
                                isPassword: true,
                                obscureText:
                                    widget.controller.isPasswordHidden.value,
                                onTogglePassword:
                                    widget.controller.togglePasswordVisibility,
                                validator: Validators.password,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => _AuthTextField(
                                hintText: "confirm_password".tr,
                                icon: Icons.lock_reset_rounded,
                                controller:
                                    widget.controller.confirmPasswordCtrl,
                                isPassword: true,
                                obscureText: widget
                                    .controller
                                    .isConfirmPasswordHidden
                                    .value,
                                onTogglePassword: widget
                                    .controller
                                    .toggleConfirmPasswordVisibility,
                                validator: (v) => Validators.confirmPassword(
                                  v,
                                  widget.controller.passwordCtrl.text,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Obx(() {
                              bool isBusy =
                                  widget.controller.isLoading.value ||
                                  widget.controller.isSuccess.value;
                              return Center(
                                child: AnimatedTap(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    height: 55,
                                    width: isBusy
                                        ? 55
                                        : MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: widget.controller.isSuccess.value
                                          ? Colors.green
                                          : AppColors.actionBlue,
                                      borderRadius: BorderRadius.circular(
                                        isBusy ? 30 : 16,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              (widget.controller.isSuccess.value
                                                      ? Colors.green
                                                      : AppColors.actionBlue)
                                                  .withOpacity(0.5),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: isBusy
                                            ? null
                                            : () {
                                                if (_step3Key.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  widget.controller.register();
                                                }
                                              },
                                        borderRadius: BorderRadius.circular(
                                          isBusy ? 30 : 16,
                                        ),
                                        child: Center(
                                          child:
                                              widget.controller.isSuccess.value
                                              ? const Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                  size: 30,
                                                )
                                              : widget
                                                    .controller
                                                    .isLoading
                                                    .value
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : Text(
                                                  "register".tr,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                            _NavigationButton(
                              title: "back".tr,
                              isOutline: true,
                              onPressed: _prevPage,
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: TextButton(
                                onPressed: widget.controller.navigateToLogin,
                                child: Obx(
                                  () => RichText(
                                    text: TextSpan(
                                      text: "have_acc".tr,
                                      style: TextStyle(
                                        color: ThemeController.to.textSecondary,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "login".tr,
                                          style: TextStyle(
                                            color: AppColors.actionBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ], // closes Column children
                        ), // closes Column
                      ), // closes Padding
                    ), // closes GlassCard
                  ), // closes Form
                ), // closes SingleChildScrollView
              ), // closes _WizardStep
            ], // closes PageView children
          ), // closes PageView
        ), // closes Expanded
      ], // closes Column children
    ); // closes return Column
  }
}

class _NavigationButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isOutline;

  const _NavigationButton({
    required this.title,
    required this.onPressed,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isOutline ? Colors.transparent : AppColors.actionBlue,
          border: isOutline
              ? Border.all(color: AppColors.actionBlue, width: 2)
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isOutline
              ? []
              : [
                  BoxShadow(
                    color: AppColors.actionBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isOutline ? AppColors.actionBlue : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: TextStyle(
            color: ThemeController.to.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AuthDropdown extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _AuthDropdown({
    required this.hintText,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return DropdownButtonFormField<String>(
        value: value,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.textSecondary,
        ),
        dropdownColor: theme.cardColor,
        style: TextStyle(color: theme.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: theme.textSecondary, size: 20),
          filled: true,
          fillColor: theme.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : AppColors.actionBlue.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.isDarkMode
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.actionBlue,
              width: 1.5,
            ),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'req'.tr : null,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ThemeController.to.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: _Glow(color: ThemeController.to.glowBlue, size: 300),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: _Glow(color: ThemeController.to.glowPurple, size: 250),
            ),
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
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _AuthTextField({
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: TextStyle(color: theme.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: theme.textSecondary, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: theme.textSecondary,
                    size: 18,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          filled: true,
          fillColor: theme.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : AppColors.actionBlue.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.isDarkMode
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.05),
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
            borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
          ),
        ),
        validator: validator,
      );
    });
  }
}
