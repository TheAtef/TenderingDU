import 'package:tendering_du/app/modules/my_bids/bid_model.dart';

class MyTenderAttachment {
  final int id;
  final String fileUrl;
  final String description;
  final int size;
  final String contentType;

  MyTenderAttachment({
    required this.id,
    required this.fileUrl,
    required this.description,
    required this.size,
    required this.contentType,
  });

  factory MyTenderAttachment.fromJson(Map<String, dynamic> json) {
    return MyTenderAttachment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fileUrl: json['file']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      contentType: json['content_type']?.toString() ?? '',
    );
  }

  String get formattedSize {
    if (size <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int index = 0;
    double displaySize = size.toDouble();
    while (displaySize >= 1024 && index < suffixes.length - 1) {
      displaySize /= 1024;
      index++;
    }
    return '${displaySize.toStringAsFixed(1)} ${suffixes[index]}';
  }
}

class MyTenderDetailsModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String currency;
  final String budgetMin;
  final String budgetMax;
  final String startDate;
  final String deadline;
  final String location;
  final List<MyTenderAttachment> attachments;
  final List<BidModel> bids;
  final bool isFavourite;

  MyTenderDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.currency,
    required this.budgetMin,
    required this.budgetMax,
    required this.startDate,
    required this.deadline,
    required this.location,
    required this.attachments,
    required this.bids,
    required this.isFavourite,
  });

  factory MyTenderDetailsModel.fromJson(Map<String, dynamic> json) {
    String formatApiDate(dynamic value) {
      if (value == null) return '';
      final text = value.toString();
      return text.contains('T') ? text.split('T')[0] : text;
    }

    String categoryName = 'N/A';
    if (json['category'] != null) {
      if (json['category'] is Map) {
        categoryName = json['category']['name']?.toString() ?? 'N/A';
      } else {
        categoryName =
            json['category_name']?.toString() ?? json['category'].toString();
      }
    }

    String statusName = 'pending';
    if (json['status'] != null) {
      if (json['status'] is Map) {
        statusName = json['status']['name']?.toString() ?? 'pending';
      } else {
        statusName = json['status'].toString();
      }
    }

    String currencyCode = 'USD';
    if (json['currency'] != null) {
      if (json['currency'] is Map) {
        currencyCode = json['currency']['code']?.toString() ?? 'USD';
      } else {
        currencyCode = json['currency'].toString();
      }
    }

    String locationText = 'Remote';
    if (json['location'] != null) {
      if (json['location'] is Map) {
        final location = json['location'] as Map;
        final street = location['street']?.toString() ?? '';
        final city = location['city']?.toString() ?? '';
        final state = location['state']?.toString() ?? '';
        final parts = <String>[];
        if (street.isNotEmpty) parts.add(street);
        if (city.isNotEmpty) parts.add(city);
        if (state.isNotEmpty) parts.add(state);
        locationText = parts.isNotEmpty ? parts.join(', ') : 'Remote';
      } else {
        locationText = json['location'].toString();
      }
    }

    final attachmentList = (json['attachments'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(MyTenderAttachment.fromJson)
        .toList();

    final bidsList = (json['bids'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(BidModel.fromJson)
        .toList();

    return MyTenderDetailsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: categoryName,
      status: statusName,
      currency: currencyCode,
      budgetMin: json['budget_min']?.toString() ?? '0',
      budgetMax: json['budget_max']?.toString() ?? '0',
      startDate: formatApiDate(json['start_date']),
      deadline: formatApiDate(json['deadline']),
      location: locationText,
      attachments: attachmentList,
      bids: bidsList,
      isFavourite: json['is_saved'] == true,
    );
  }
}
