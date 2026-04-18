import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';
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
                        _SectionTitle(title: "Preferences"),
                        _PreferencesSection(controller: controller),
                        const SizedBox(height: 24),
                        _SectionTitle(title: "Notifications"),
                        _NotificationsSection(controller: controller),
                        const SizedBox(height: 24),
                        _SectionTitle(title: "Security"),
                        _SecuritySection(controller: controller),
                        const SizedBox(height: 24),
                        _SectionTitle(title: "General"),
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
              _AnimatedTap(
                child: _GlassIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Get.back(),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "Settings",
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
              title: "Dark Mode",
              subtitle: controller.themeController.isDarkMode
                  ? "Dark theme enabled"
                  : "Light theme enabled",
              value: controller.themeController.isDarkMode,
              onChanged: controller.toggleTheme,
            ),
          ),
          const _Divider(),
          Obx(
            () => _ActionTile(
              icon: Icons.language_rounded,
              title: "Language",
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
              "Select Language",
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
              title: "Push Notifications",
              subtitle: "Receive app notifications",
              value: controller.pushNotifications.value,
              onChanged: controller.togglePushNotifications,
            ),
          ),
          const _Divider(),
          Obx(
            () => _SwitchTile(
              icon: Icons.alarm_rounded,
              title: "Deadline Reminders",
              subtitle: "Alert before tender deadlines",
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
            title: "Change Password",
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
            title: "Help & Support",
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
            title: "About",
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
                    title,
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
    return _AnimatedTap(
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
                    title,
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

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: theme.isDarkMode
                ? Colors.white10
                : AppColors.actionBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.borderColor),
          ),
          child: Icon(icon, color: theme.textPrimary, size: 20),
        ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.97),
      onTapUp: (_) => setState(() => scale = 1),
      onTapCancel: () => setState(() => scale = 1),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
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
            "Version 1.0.0",
            style: TextStyle(color: theme.textSecondary, fontSize: 12),
          ),
        ),
      );
    });
  }
}
