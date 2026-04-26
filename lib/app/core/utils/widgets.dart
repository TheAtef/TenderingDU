import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/constants/app_colors.dart';
import 'package:tendering_du/app/core/theme/theme_controller.dart';

class Glow extends StatelessWidget {
  final Color color;
  final double size;
  const Glow({required this.color, required this.size});

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

class StaticBackground extends StatelessWidget {
  const StaticBackground();

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
              child: Glow(color: theme.glowBlue, size: 300),
            ),
            Positioned(
              bottom: 100,
              left: -50,
              child: Glow(color: theme.glowPurple, size: 250),
            ),
          ],
        ),
      );
    });
  }
}

class AnimatedTap extends StatefulWidget {
  final Widget child;
  const AnimatedTap({required this.child});
  @override
  State<AnimatedTap> createState() => AnimatedTapState();
}

class AnimatedTapState extends State<AnimatedTap> {
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

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const GlassIconButton({required this.icon, required this.onTap});

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

class InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.isDarkMode
              ? Colors.white10
              : AppColors.actionBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: theme.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: theme.textPrimary, fontSize: 12),
            ),
          ],
        ),
      );
    });
  }
}
