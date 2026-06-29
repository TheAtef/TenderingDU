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
    return MyTenderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 'Draft',
      budget: json['budget'] ?? '',
      deadline: json['deadline'] ?? '',
      bidsCount: json['bids_count'] ?? 0,
      description: json['description'] ?? '',
      isPinned: json['is_pinned'] ?? false,
    );
  }
}
