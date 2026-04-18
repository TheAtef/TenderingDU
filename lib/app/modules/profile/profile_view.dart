import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/modules/profile/profile_controller.dart';
import 'package:tendering_du/app/routes/app_routes.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';

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
                  builder: (context) => _AnimatedTap(
                    child: _GlassIconButton(
                      icon: Icons.menu,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    _AnimatedTap(
                      child: _GlassIconButton(
                        icon: Icons.edit_rounded,
                        onTap: () {},
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
                      controller.profile.value?.name ?? '',
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
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => scale = 1),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
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
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
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
