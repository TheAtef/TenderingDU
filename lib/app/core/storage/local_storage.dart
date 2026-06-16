import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();

  static const String _themeKey = 'isDarkMode';

  static bool getDarkMode() => _box.read(_themeKey) ?? true;
  static Future<void> setDarkMode(bool value) async =>
      await _box.write(_themeKey, value);

  static Future<void> clearAll() async => await _box.erase();

  static void saveNotificationReadStatus(String id, bool isRead) {
    final List<Map<String, dynamic>> notifications =
        List<Map<String, dynamic>>.from(_box.read('notifications') ?? []);

    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      notifications[index]['isRead'] = isRead;
    } else {
      notifications.add({'id': id, 'isRead': isRead});
    }

    _box.write('notifications', notifications);
  }
}
