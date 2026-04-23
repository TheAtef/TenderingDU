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
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      deadline: json['deadline'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      estimatedBudget: json['estimated_budget'] ?? '\$0',
      requirements: List<String>.from(json['requirements'] ?? []),
      pdfUrl: json['pdf_url'] ?? '',
      isFavourite: json['is_favourite'] == true,
      postedDate: json['postedDate'],
    );
  }
}
