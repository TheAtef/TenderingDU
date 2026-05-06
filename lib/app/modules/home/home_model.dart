class Tender {
  final int id;
  final String title;
  final String description;
  final DateTime? deadline;
  final String category;
  final String status;
  bool isFavourite;

  Tender({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.category,
    required this.status,
    this.isFavourite = false,
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

    return Tender(
      id: json['id'] as int,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'])
          : null,
      category: categoryName,
      status: json['status_name'] ?? 'active',
      isFavourite: json['is_favourite'] ?? false,
    );
  }
}
