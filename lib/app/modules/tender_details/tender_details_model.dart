class TenderDetailsModel {
  final int id;
  final String title;
  final String description;
  final String deadline;
  final String category;
  final String status;
  final String estimatedBudget;
  final List<String> requirements;
  bool isFavourite;

  TenderDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.category,
    required this.status,
    required this.estimatedBudget,
    required this.requirements,
    this.isFavourite = false,
  });

  factory TenderDetailsModel.fromJson(Map<String, dynamic> json) {
    return TenderDetailsModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deadline: json['deadline'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      estimatedBudget: json['estimated_budget'] ?? '\$0',
      requirements: List<String>.from(json['requirements'] ?? []),
      isFavourite: json['is_favourite'] == true,
    );
  }
}
