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
}
