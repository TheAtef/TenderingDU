class Tender {
  final int id;
  final String title;
  final String description;
  final String deadline;
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
  factory Tender.fromJson(Map<String, dynamic> json) {
    List<dynamic> fields = json['fields_detail'] ?? [];
    String categoryDisplay = fields.isNotEmpty
        ? fields.map((f) => f['name'].toString()).join(', ')
        : 'General';

    return Tender(
      id: json['id'] as int,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      deadline: json['end_date']?.toString() ?? '',
      category: categoryDisplay,
      status: json['status'] ?? 'active',
      isFavourite: json['is_favourite'] ?? false,
    );
  }
}
