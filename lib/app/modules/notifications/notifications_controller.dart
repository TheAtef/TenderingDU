import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_model.dart';

class NotificationsController extends GetxController {
  final scrollCtrl = ScrollController();

  var isLoading = true.obs;
  var activeFilter = 'All'.obs;
  var notificationsList = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  @override
  void onClose() {
    scrollCtrl.dispose();
    super.onClose();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));

    notificationsList.assignAll([
      NotificationModel(
        id: '1',
        title: 'New Tender Match',
        message:
            'A new tender "Highway Construction Phase 2" matches your profile criteria.',
        timeAgo: '10 mins ago',
        type: 'tender',
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Bid Submitted Successfully',
        message:
            'Your bid for "IT Infrastructure Upgrade" has been received and is under review.',
        timeAgo: '2 hours ago',
        type: 'success',
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Deadline Approaching',
        message:
            'The submission deadline for "Healthcare Software System" is in 2 days.',
        timeAgo: '1 day ago',
        type: 'alert',
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'System Maintenance',
        message:
            'The portal will be down for scheduled maintenance this Saturday at 12:00 AM.',
        timeAgo: '2 days ago',
        type: 'info',
        isRead: true,
      ),
    ]);

    isLoading.value = false;
  }

  Future<void> refreshAll() async {
    await fetchNotifications();
  }

  void applyFilter(String filter) {
    activeFilter.value = filter;
  }

  void markAllAsRead() {
    for (var note in notificationsList) {
      note.isRead = true;
    }
    notificationsList.refresh();
  }

  void toggleReadStatus(NotificationModel notification) {
    notification.isRead = !notification.isRead;
    notificationsList.refresh();
  }

  void deleteNotification(String id) {
    notificationsList.removeWhere((item) => item.id == id);
  }

  List<NotificationModel> get filteredNotifications {
    if (activeFilter.value == 'Unread') {
      return notificationsList.where((n) => !n.isRead).toList();
    } else if (activeFilter.value == 'Alerts') {
      return notificationsList
          .where((n) => n.type == 'alert' || n.type == 'tender')
          .toList();
    }
    return notificationsList;
  }
}
