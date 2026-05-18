import 'package:flutter/material.dart';

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
  final String pdfUrl;
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
    required this.pdfUrl,
    this.isFavourite = false,
  });

  factory TenderDetailsModel.fromJson(Map<String, dynamic> json) {
    String formatApiDate(dynamic date) {
      if (date == null) return '';
      String dateStr = date.toString();
      return dateStr.contains('T') ? dateStr.split('T')[0] : dateStr;
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
      pdfUrl: json['pdf_url']?.toString() ?? '',
      isFavourite: json['is_favourite'] == true,
    );
  }
  String get budgetRange => "$currency $budgetMin - $budgetMax";
}
