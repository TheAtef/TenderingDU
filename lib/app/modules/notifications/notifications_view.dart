import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:tendering_du/app/core/constants/app_colors.dart';

import 'notifications_controller.dart';
import 'notifications_model.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkNavy,
      body: Stack(
        children: [
          const _StaticBackground(),
          _MainContent(controller: controller),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final NotificationsController controller;
  const _MainContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshAll,
      color: AppColors.actionBlue,
      backgroundColor: AppColors.darkNavy,
      child: CustomScrollView(
        controller: controller.scrollCtrl,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _HeroHeader(controller: controller),
          _CategoryChips(controller: controller),
          _NotificationCardsSection(controller: controller),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _StaticBackground extends StatelessWidget {
  const _StaticBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B2A), Color(0xFF1B2846), Color(0xFF273557)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: _Glow(
              color: AppColors.actionBlue.withOpacity(0.2),
              size: 300,
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: _Glow(color: AppColors.errorRed.withOpacity(0.1), size: 250),
          ),
        ],
      ),
    );
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

class _HeroHeader extends StatelessWidget {
  final NotificationsController controller;
  const _HeroHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AnimatedTap(
                  child: _GlassIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Get.back(),
                  ),
                ),
                _AnimatedTap(
                  child: InkWell(
                    onTap: controller.markAllAsRead,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.actionBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.actionBlue.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.done_all,
                            color: AppColors.actionBlue,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Mark all read",
                            style: TextStyle(
                              color: AppColors.actionBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Obx(() {
                  final unreadCount = controller.notificationsList
                      .where((n) => !n.isRead)
                      .length;
                  if (unreadCount == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$unreadCount New",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final NotificationsController controller;
  const _CategoryChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = ["All", "Unread", "Alerts"];

    return SliverToBoxAdapter(
      child: Obx(() {
        final currentFilter = controller.activeFilter.value;

        return Container(
          height: 45,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final isActive = currentFilter == categories[i];

              return GestureDetector(
                onTap: () => controller.applyFilter(categories[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.actionBlue
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? AppColors.actionBlue
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.greyBlue,
                      fontSize: 14,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _NotificationCardsSection extends StatelessWidget {
  final NotificationsController controller;
  const _NotificationCardsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, _) => const _ShimmerCard(),
              childCount: 5,
            ),
          ),
        );
      }

      final filteredList = controller.filteredNotifications;

      if (filteredList.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 60,
                    color: AppColors.greyBlue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No notifications found",
                    style: TextStyle(color: AppColors.greyBlue, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: AnimationLimiter(
          child: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final notification = filteredList[index];

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 400),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Dismissible(
                      key: Key(notification.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) =>
                          controller.deleteNotification(notification.id),
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      child: _AnimatedTap(
                        child: GestureDetector(
                          onTap: () =>
                              controller.toggleReadStatus(notification),
                          child: _ModernNotificationCard(
                            notification: notification,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: filteredList.length),
          ),
        ),
      );
    });
  }
}

class _ModernNotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const _ModernNotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    // Determine Icon and Color based on notification type
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'tender':
        iconData = Icons.description_outlined;
        iconColor = AppColors.actionBlue;
        break;
      case 'success':
        iconData = Icons.check_circle_outline;
        iconColor = Colors.greenAccent;
        break;
      case 'alert':
        iconData = Icons.warning_amber_rounded;
        iconColor = AppColors.errorRed;
        break;
      case 'info':
      default:
        iconData = Icons.info_outline_rounded;
        iconColor = AppColors.greyBlue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white.withOpacity(0.02)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: notification.isRead
              ? Colors.transparent
              : Colors.white.withOpacity(0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: notification.isRead
                              ? FontWeight.w600
                              : FontWeight.bold,
                          color: notification.isRead
                              ? Colors.white70
                              : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.actionBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: notification.isRead
                        ? AppColors.greyBlue
                        : Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.greyBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      notification.timeAgo,
                      style: const TextStyle(
                        color: AppColors.greyBlue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
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

  void _onTapDown(TapDownDetails details) => setState(() => scale = 0.95);
  void _onTapUp(TapUpDetails details) => setState(() => scale = 1);
  void _onTapCancel() => setState(() => scale = 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();
  @override
  Widget build(BuildContext context) => Container(
    height: 120,
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(24),
    ),
  );
}
