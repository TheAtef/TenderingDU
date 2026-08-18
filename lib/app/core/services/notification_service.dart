import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'api_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" ========================================== ");
  print(" BACKGROUND MESSAGE RAW DATA: ${message.data}");
  print(" BACKGROUND NOTIFICATION TITLE: ${message.notification?.title}");
  print(" BACKGROUND NOTIFICATION BODY: ${message.notification?.body}");
  print(" ========================================== ");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiService _apiService = ApiService();

  Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permissions.');
    } else {
      print('User declined or has not accepted permission.');
      return;
    }

    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
      await sendTokenToBackend(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      sendTokenToBackend(newToken);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.messageId}');
      print('Notification Title: ${message.notification?.title}');
      print('Notification Body: ${message.notification?.body}');
      print('Data payload: ${message.data}');

      String title =
          message.notification?.title ??
          message.data['title'] ??
          'New Notification';
      String body =
          message.notification?.body ??
          message.data['body'] ??
          message.data['message'] ??
          'You have a new update';

      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.notifications_active, color: Colors.white),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });
  }

  Future<void> sendTokenToBackend(String token) async {
    try {
      final success = await _apiService.updateFcmToken(token);
      if (success) {
        print("FCM Token successfully registered with backend.");
      }
    } catch (e) {
      print("Failed to sync FCM token: $e");
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    String? type = data['type'];
    String? tenderId = data['tender_id'];

    if (type == 'tender_approved' && tenderId != null) {
      // Get.toNamed(Routes.TENDER_DETAILS, arguments: int.parse(tenderId));
    }
  }
}
