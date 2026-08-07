class MyTenderModel {
  final int id;
  final String title;
  final String category;
  final String status;
  final String budget;
  final String deadline;
  final int bidsCount;
  final String description;
  final bool isPinned;

  const MyTenderModel({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.budget,
    required this.deadline,
    required this.bidsCount,
    required this.description,
    this.isPinned = false,
  });

  factory MyTenderModel.fromJson(Map<String, dynamic> json) {
    String resolveName(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      if (value is Map) {
        return value['name']?.toString() ??
            value['title']?.toString() ??
            value['label']?.toString() ??
            fallback;
      }
      return value.toString();
    }

    String resolveDate(dynamic value) {
      if (value == null) return '';
      final dateText = value.toString();
      return dateText.contains('T') ? dateText.split('T')[0] : dateText;
    }

    return MyTenderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      category:
          json['category_name']?.toString() ??
          resolveName(json['category'], fallback: ''),
      status:
          json['status_name']?.toString() ??
          resolveName(json['status'], fallback: 'Draft'),
      budget:
          json['budget']?.toString() ??
          json['budget_max']?.toString() ??
          json['budget_min']?.toString() ??
          '',
      deadline: resolveDate(json['deadline']),
      bidsCount:
          (json['bids_count'] as num?)?.toInt() ??
          (json['bids'] is List ? (json['bids'] as List).length : 0),
      description: json['description']?.toString() ?? '',
      isPinned: json['is_pinned'] == true,
    );
  }
}
