import 'package:flutter/material.dart';

// Represents an attached document from the backend TenderAttachment table
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
      id: json['id'] ?? 0,
      fileUrl:
          json['file'] ??
          '', // Django serializes FileField under the key 'file'
      description: json['description'] ?? '',
      size: json['size'] ?? 0,
      contentType: json['content_type'] ?? '',
    );
  }

  // Helper to convert size in bytes to a human-readable String (e.g. "1.2 MB")
  String get formattedSize {
    if (size <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    int i = 0;
    double dSize = size.toDouble();
    while (dSize >= 1024 && i < suffixes.length - 1) {
      dSize /= 1024;
      i++;
    }
    return "${dSize.toStringAsFixed(1)} ${suffixes[i]}";
  }
}

class TenderDetailsModel {
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
  final List<String> requirements;
  final List<Attachment> attachments;
  bool isFavourite;

  TenderDetailsModel({
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
    required this.requirements,
    required this.attachments,
    this.isFavourite = false,
  });

  factory TenderDetailsModel.fromJson(Map<String, dynamic> json) {
    String formatApiDate(dynamic date) {
      if (date == null) return '';
      String dateStr = date.toString();
      return dateStr.contains('T') ? dateStr.split('T')[0] : dateStr;
    }

    // Parse the nested attachments array
    var attachmentList = <Attachment>[];
    if (json['attachments'] != null) {
      attachmentList = (json['attachments'] as List)
          .map((x) => Attachment.fromJson(x))
          .toList();
    }

    return TenderDetailsModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category:
          json['category_name']?.toString() ??
          json['category']?.toString() ??
          'N/A',
      status: json['status']?.toString() ?? 'pending',
      currency: json['currency']?.toString() ?? 'USD',
      budgetMin: json['budget_min']?.toString() ?? '0',
      budgetMax: json['budget_max']?.toString() ?? '0',
      startDate: formatApiDate(json['start_date']),
      deadline: formatApiDate(json['deadline']),
      location: json['location']?.toString() ?? 'Remote',
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'].map((x) => x.toString()))
          : [],
      attachments: attachmentList,

      isFavourite: json['is_saved'] == true,
    );
  }

  String get budgetRange => "$currency $budgetMin - $budgetMax";
}
