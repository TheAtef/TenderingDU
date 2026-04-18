class Bid {
  final int id;
  final String title;
  final String description;
  final String deadline;
  final String category;
  final String status;
  final String bidDetails;
  final bool isWinningBid;

  Bid({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.category,
    required this.status,
    required this.bidDetails,
    required this.isWinningBid,
  });
}
