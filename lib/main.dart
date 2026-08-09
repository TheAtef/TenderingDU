import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/core/services/notification_service.dart';
import 'package:tendering_du/app/core/services/translations.dart';
import 'package:tendering_du/app/core/theme/initial_binding.dart';
import 'package:tendering_du/app/core/storage/local_storage.dart';
import 'package:tendering_du/app/core/theme/app_theme.dart';
import 'package:tendering_du/app/routes/app_pages.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await GetStorage.init();
      try {
        await Firebase.initializeApp();
        print("Firebase initialized successfully.");
      } catch (e) {
        print("Firebase init error: $e");
      }
      usePathUrlStrategy();
      Get.put(ApiService(), permanent: true);
      try {
        await NotificationService().initialize();
      } catch (e) {
        print("NotificationService init error: $e");
      }
      runApp(const MyApp());
    },
    (error, stack) {
      log("CRASHED DURING STARTUP: $error", error: error, stackTrace: stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    try {
      isDarkMode = StorageService.getDarkMode();
    } catch (_) {}
    return GetMaterialApp(
      title: 'TenderingDU',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      translations: TranslationsService(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return Container(
          color: Colors.white,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
