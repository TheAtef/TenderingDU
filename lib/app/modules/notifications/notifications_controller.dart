import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/core/storage/local_storage.dart';
import 'notifications_model.dart';

class NotificationsController extends GetxController {
  final scrollCtrl = ScrollController();
  final _apiService = ApiService();
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
    _apiService
        .getNotifications()
        .then((response) {
          if (response.isNotEmpty) {
            notificationsList.assignAll(
              response.map((json) => NotificationModel.fromJson(json)).toList(),
            );
          }
        })
        .catchError((error) {
          Get.snackbar('Error', 'Failed to fetch notifications: $error');
        });

    await Future.delayed(const Duration(milliseconds: 500));

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
      StorageService.saveNotificationReadStatus(note.id, note.isRead);
    }

    notificationsList.refresh();
  }

  void toggleReadStatus(NotificationModel notification) {
    notification.isRead = !notification.isRead;
    StorageService.saveNotificationReadStatus(
      notification.id,
      notification.isRead,
    );
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
