import 'dart:ui';

import 'package:flutter/material.dart';

class TenderDetailsModel {
  final int id;
  final String title;
  final String description;
  final String deadline;
  final String category;
  final String status;
  final String estimatedBudget;
  final List<String> requirements;
  final String pdfUrl;
  bool isFavourite;
  final String postedDate;
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'won':
        return Colors.green;
      case 'lost':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  TenderDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.category,
    required this.status,
    required this.estimatedBudget,
    required this.requirements,
    required this.pdfUrl,
    required this.postedDate,

    this.isFavourite = false,
  });

  factory TenderDetailsModel.fromJson(Map<String, dynamic> json) {
    return TenderDetailsModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      deadline: json['deadline']?.toString() ?? '',
      category:
          json['category_name']?.toString() ??
          json['category']?.toString() ??
          '',
      status:
          json['status_name']?.toString() ?? json['status']?.toString() ?? '',
      estimatedBudget: json['estimated_budget']?.toString() ?? '0',
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'].map((x) => x.toString()))
          : [],
      pdfUrl: json['pdf_url']?.toString() ?? '',
      isFavourite: json['is_favourite'] == true,
      postedDate:
          json['posted_at']?.toString() ?? json['postedDate']?.toString() ?? '',
    );
  }
}
