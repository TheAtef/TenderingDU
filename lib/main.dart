// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tendering_du/app/core/services/api_service.dart';
import 'package:tendering_du/app/core/theme/initial_binding.dart';
import 'package:tendering_du/app/core/storage/local_storage.dart';
import 'package:tendering_du/app/core/theme/app_theme.dart';
import 'package:tendering_du/app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ApiService(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TenderingDU',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: StorageService.getDarkMode()
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}
