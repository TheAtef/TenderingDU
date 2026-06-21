import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
import 'package:tendering_du/app/core/utils/responsive_layout.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Scaffold(
        backgroundColor: theme.backgroundColor,
        body: Stack(
          children: [
            const _StaticBackground(),
            ResponsiveLayout(
              mobile: _buildMobileLayout(context),
              desktop: _buildDesktopLayout(context),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _Header(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _SectionTitle(title: "preferences".tr),
                    _PreferencesSection(controller: controller),
                    const SizedBox(height: 24),
                    _SectionTitle(title: "notifications".tr),
                    _NotificationsSection(controller: controller),
                    const SizedBox(height: 24),
                    _SectionTitle(title: "security".tr),
                    _SecuritySection(controller: controller),
                    const SizedBox(height: 24),
                    _SectionTitle(title: "general".tr),
                    _GeneralSection(controller: controller),
                    const SizedBox(height: 24),
                    _AppVersion(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1300),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(12),
                      hoverColor: AppColors.actionBlue.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_rounded,
                              color: ThemeController.to.textPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "back".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ThemeController.to.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "settings".tr,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: ThemeController.to.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Manage your app preferences, security settings, and notifications to tailor the experience to your needs.",
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeController.to.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const Spacer(),
                    _AppVersion(),
                  ],
                ),
              ),
              const SizedBox(width: 80),

              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDesktopSection(
                          "preferences",
                          _PreferencesSection(controller: controller),
                        ),
                        const SizedBox(height: 40),
                        _buildDesktopSection(
                          "notifications",
                          _NotificationsSection(controller: controller),
                        ),
                        const SizedBox(height: 40),
                        _buildDesktopSection(
                          "security",
                          _SecuritySection(controller: controller),
                        ),
                        const SizedBox(height: 40),
                        _buildDesktopSection(
                          "general",
                          _GeneralSection(controller: controller),
                        ),
                        const SizedBox(height: 60),
                      ],
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

  Widget _buildDesktopSection(String titleKey, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 4),
          child: Text(
            titleKey.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ThemeController.to.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        child,
      ],
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
            Positioned(
              top: -50,
              right: -50,
              child: _Glow(color: theme.glowBlue, size: 300),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: _Glow(color: theme.glowPurple, size: 250),
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Obx(() {
          final theme = ThemeController.to;
          return Row(
            children: [
              AnimatedTap(
                child: GlassIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "settings".tr,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: theme.textPrimary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
      );
    });
  }
}

class _PreferencesSection extends StatelessWidget {
  final SettingsController controller;
  const _PreferencesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        children: [
          Obx(
            () => _SwitchTile(
              icon: Icons.dark_mode_rounded,
              title: "dark_mode".tr,
              subtitle: controller.themeController.isDarkMode
                  ? "dark_mode_enabled".tr
                  : "light_mode_enabled".tr,
              value: controller.themeController.isDarkMode,
              onChanged: controller.toggleTheme,
            ),
          ),
          const _Divider(),
          Obx(
            () => _ActionTile(
              icon: Icons.language_rounded,
              title: "language".tr,
              trailing: Text(
                controller.selectedLanguage.value,
                style: const TextStyle(
                  color: AppColors.actionBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _openLanguageSelector(context, controller),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  final SettingsController controller;
  const _NotificationsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        children: [
          Obx(
            () => _SwitchTile(
              icon: Icons.notifications_rounded,
              title: "push_notifications".tr,
              subtitle: "receive_app_notif".tr,
              value: controller.pushNotifications.value,
              onChanged: controller.togglePushNotifications,
            ),
          ),
          const _Divider(),
          Obx(
            () => _SwitchTile(
              icon: Icons.alarm_rounded,
              title: "deadline_reminders".tr,
              subtitle: "alert_before_deadline".tr,
              value: controller.deadlineReminders.value,
              onChanged: controller.toggleDeadlineReminders,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  final SettingsController controller;
  const _SecuritySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.lock_rounded,
            title: "change_password".tr,
            trailing: Obx(
              () => Icon(
                Icons.chevron_right_rounded,
                color: ThemeController.to.textSecondary,
              ),
            ),
            onTap: controller.otpPage,
          ),
        ],
      ),
    );
  }
}

class _GeneralSection extends StatelessWidget {
  final SettingsController controller;
  const _GeneralSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.help_outline_rounded,
            title: "help_support".tr,
            trailing: Obx(
              () => Icon(
                Icons.chevron_right_rounded,
                color: ThemeController.to.textSecondary,
              ),
            ),
            onTap: () {},
          ),
          const _Divider(),
          _ActionTile(
            icon: Icons.info_outline_rounded,
            title: "about".tr,
            trailing: Obx(
              () => Icon(
                Icons.chevron_right_rounded,
                color: ThemeController.to.textSecondary,
              ),
            ),
            onTap: () {},
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
      final isDesktop = ResponsiveLayout.isDesktop(context);
      return Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? 16 : 20),
          border: Border.all(color: theme.borderColor),
          boxShadow: theme.isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: child,
      );
    });
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Divider(
        color: theme.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        height: 1,
        indent: 68,
        endIndent: 16,
      );
    });
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      final isDesktop = ResponsiveLayout.isDesktop(context);

      return InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 20),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : 16,
            vertical: isDesktop ? 16 : 12,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.actionBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.actionBlue, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: isDesktop ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: AppColors.actionBlue,
                inactiveThumbColor: theme.textSecondary,
                inactiveTrackColor: theme.isDarkMode
                    ? Colors.white10
                    : Colors.black12,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return AnimatedTap(
      child: InkWell(
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 16),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : 16,
            vertical: isDesktop ? 20 : 16,
          ),
          child: Obx(() {
            final theme = ThemeController.to;
            return Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.actionBlue, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: isDesktop ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _AppVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Text(
        "app_version".tr,
        style: TextStyle(color: theme.textSecondary, fontSize: 13),
      );
    });
  }
}

void _openLanguageSelector(BuildContext context, SettingsController ctrl) {
  final theme = ThemeController.to;

  final child = Container(
    padding: const EdgeInsets.all(28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Language".tr,
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...ctrl.languages.map(
          (lang) => Obx(
            () => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hoverColor: AppColors.actionBlue.withOpacity(0.08),
              title: Text(
                lang,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: ctrl.selectedLanguage.value == lang
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
              trailing: ctrl.selectedLanguage.value == lang
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.actionBlue,
                    )
                  : null,
              onTap: () {
                ctrl.changeLanguage(lang);
                Get.back();
              },
            ),
          ),
        ),
      ],
    ),
  );

  if (ResponsiveLayout.isDesktop(context)) {
    Get.dialog(
      Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: child,
        ),
      ),
    );
  } else {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: child,
      ),
      isScrollControlled: true,
    );
  }
}
