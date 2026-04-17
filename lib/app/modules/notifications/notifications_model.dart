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
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
      type: json['type'] ?? 'info',
      isRead: json['isRead'] ?? false,
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
}
