import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
import 'package:tendering_du/app/core/utils/widgets.dart';
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
            SafeArea(
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
          ],
        ),
      );
    });
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
          title.tr,
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _showLanguageSheet(context, controller),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, SettingsController ctrl) {
    final theme = ThemeController.to;
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Language".tr,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...ctrl.languages.map(
              (lang) => Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lang, style: TextStyle(color: theme.textPrimary)),
                  trailing: ctrl.selectedLanguage.value == lang
                      ? const Icon(
                          Icons.check_rounded,
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
            onTap: controller.changePassword,
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
        indent: 60,
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.actionBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.actionBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle.tr,
                    style: TextStyle(color: theme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
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
    return AnimatedTap(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Obx(() {
            final theme = ThemeController.to;
            return Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.actionBlue, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title.tr,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            "app_version".tr,
            style: TextStyle(color: theme.textSecondary, fontSize: 12),
          ),
        ),
      );
    });
  }
}
