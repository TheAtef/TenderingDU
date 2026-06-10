class Attachment {
  final int id;
  final String fileUrl;
  final String description;
  final int size;
  final String contentType;

  Attachment({
    required this.id,
    required this.fileUrl,
    required this.description,
    required this.size,
    required this.contentType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fileUrl: json['file']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      contentType: json['content_type']?.toString() ?? '',
    );
  }
}

class Tender {
  final int id;
  final String title;
  final String description;
  final DateTime? deadline;
  final String category;
  final String status;
  bool isFavourite;
  final List<Attachment> attachments;

  Tender({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.category,
    required this.status,
    this.isFavourite = false,
    required this.attachments,
  });

  String get daysLeft {
    if (deadline == null) return "No deadline";
    final now = DateTime.now();
    final difference = deadline!.difference(now);
    if (difference.isNegative) return "Expired";
    if (difference.inDays == 0) return "Due today";
    return "${difference.inDays} days left";
  }

  factory Tender.fromJson(
    Map<String, dynamic> json,
    Map<int, String> categoryMap,
  ) {
    final int tenderId = (json['id'] as num?)?.toInt() ?? 0;

    String categoryName = "General";
    if (json['category'] != null) {
      if (json['category'] is Map) {
        categoryName = json['category']['name']?.toString() ?? "General";
      } else if (json['category'] is int) {
        categoryName = categoryMap[json['category']] ?? "General";
      } else {
        categoryName = json['category'].toString();
      }
    }

    String statusName = "active";
    if (json['status'] != null) {
      if (json['status'] is Map) {
        statusName = json['status']['name']?.toString() ?? "active";
      } else {
        statusName = json['status_name'] ?? json['status'].toString();
      }
    }

    var attachmentList = <Attachment>[];
    if (json['attachments'] != null) {
      attachmentList = (json['attachments'] as List)
          .map((item) => Attachment.fromJson(item))
          .toList();
    }

    return Tender(
      id: tenderId,
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'].toString())
          : null,
      category: categoryName,
      status: statusName,
      isFavourite: json['is_saved'] == true,
      attachments: attachmentList,
    );
  }
}
