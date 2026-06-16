import 'package:get_storage/get_storage.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final String type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['tender_title'] ?? '',
      message: json['message'] ?? '',
      timeAgo: convertToTimeAgo(DateTime.parse(json['created_at'].toString())),
      type: json['notification_type'] ?? 'info',
      isRead: checkLocalReadStatus(json['id'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timeAgo': timeAgo,
      'type': type,
      'isRead': isRead,
    };
  }

  static bool checkLocalReadStatus(String string) {
    final List<Map<String, dynamic>> notifications =
        List<Map<String, dynamic>>.from(
          GetStorage().read('notifications') ?? [],
        );

    final index = notifications.indexWhere((n) => n['id'] == string);
    if (index != -1) {
      return notifications[index]['isRead'] ?? false;
    }
    return false;
  }
}

String convertToTimeAgo(DateTime input) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 365) {
    return '${(diff.inDays / 365).floor()} year(s) ago';
  } else if (diff.inDays >= 30) {
    return '${(diff.inDays / 30).floor()} month(s) ago';
  } else if (diff.inDays >= 1) {
    return '${diff.inDays} day(s) ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour(s) ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute(s) ago';
  } else {
    return 'Just now';
  }
}
