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
      id: json['id'] as int,
      fileUrl: json['file'] ?? '',
      description: json['description'] ?? '',
      size: json['size'] ?? 0,
      contentType: json['content_type'] ?? '',
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
    final int categoryId = json['category'] ?? 0;
    final String categoryName = categoryMap[categoryId] ?? "General";

    var attachmentList = <Attachment>[];
    if (json['attachments'] != null) {
      attachmentList = (json['attachments'] as List)
          .map((item) => Attachment.fromJson(item))
          .toList();
    }

    return Tender(
      id: json['id'] as int,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'])
          : null,
      category: categoryName,
      status: json['status_name'] ?? 'active',
      isFavourite: json['is_saved'] ?? false,
      attachments: attachmentList,
    );
  }
}
