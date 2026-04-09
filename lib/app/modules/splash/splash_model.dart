class SplashModel {
  final String title;
  final String subTitle;

  SplashModel({
    required this.title,
    required this.subTitle,
  });

  // If you ever fetch this data from an API (e.g., checking for app updates)
  factory SplashModel.fromJson(Map<String, dynamic> json) {
    return SplashModel(
      title: json['title'] ?? 'TenderingDU',
      subTitle: json['subTitle'] ?? 'Your Gate to Business',
    );
  }
}
