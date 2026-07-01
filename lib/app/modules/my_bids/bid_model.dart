class BidDocumentModel {
  final int id;
  final String fileUrl;
  final String description;

  BidDocumentModel({
    required this.id,
    required this.fileUrl,
    required this.description,
  });

  factory BidDocumentModel.fromJson(Map<String, dynamic> json) {
    return BidDocumentModel(
      id: json['id'] ?? 0,
      fileUrl: json['file'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class BidModel {
  final int id;
  final String userName;
  final String tenderTitle;
  final String statusName;
  final String proposal;
  final double totalPrice;
  final String executionPlan;
  final String deliverables;
  final String estimatedDuration;
  final String companyName;
  final String contactPerson;
  final String contactEmail;
  final String contactPhone;
  final String tenderOwner;
  final List<BidEvaluationModel> evaluations;
  final List<BidDocumentModel> documents;

  BidModel({
    required this.id,
    required this.userName,
    required this.tenderTitle,
    required this.statusName,
    required this.proposal,
    required this.totalPrice,
    required this.executionPlan,
    required this.deliverables,
    required this.estimatedDuration,
    required this.companyName,
    required this.contactPerson,
    required this.contactEmail,
    required this.contactPhone,
    required this.documents,
    required this.tenderOwner,
    required this.evaluations,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    var evalList = json['evaluations'] as List? ?? [];
    List<BidEvaluationModel> parsedEvaluations = evalList
        .map((e) => BidEvaluationModel.fromJson(e))
        .toList();
    return BidModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? 'Unknown',
      tenderTitle: json['tender_title'] ?? 'Unknown Tender',
      statusName: json['status_name'] ?? 'Pending',
      proposal: json['proposal'] ?? '',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      executionPlan: json['execution_plan'] ?? 'No execution plan provided',
      deliverables: json['deliverables'] ?? 'No deliverables provided',
      estimatedDuration: json['estimated_duration'] ?? 'Not specified',
      companyName: json['company_name'] ?? '',
      contactPerson: json['contact_person'] ?? 'Not specified',
      contactEmail: json['contact_email'] ?? 'Not specified',
      contactPhone: json['contact_phone'] ?? 'Not specified',
      tenderOwner: json['tender_owner_username']?.toString() ?? '',
      evaluations: parsedEvaluations,
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => BidDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BidEvaluationModel {
  final int id;
  final double score;
  final String comments;
  final String decision;
  final DateTime? evaluatedAt;

  BidEvaluationModel({
    required this.id,
    required this.score,
    required this.comments,
    required this.decision,
    this.evaluatedAt,
  });

  factory BidEvaluationModel.fromJson(Map<String, dynamic> json) {
    return BidEvaluationModel(
      id: json['id'] as int? ?? 0,
      score: double.tryParse(json['score']?.toString() ?? '0.0') ?? 0.0,
      comments: json['comments'] ?? '',
      decision: json['decision'] ?? 'Pending',
      evaluatedAt: json['evaluated_at'] != null
          ? DateTime.tryParse(json['evaluated_at'])
          : null,
    );
  }
}
