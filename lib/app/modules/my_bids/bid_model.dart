class BidDocumentModel {
  final int id;
  final String fileUrl;
  final String description;
  final int size;
  final String contentType;

  BidDocumentModel({
    required this.id,
    required this.fileUrl,
    required this.description,
    required this.size,
    required this.contentType,
  });

  factory BidDocumentModel.fromJson(Map<String, dynamic> json) {
    return BidDocumentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fileUrl: json['file']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      contentType: json['content_type']?.toString() ?? '',
    );
  }
}

class BidModel {
  final int id;
  final String title;
  final String proposal;
  final double totalPrice;
  final String executionPlan;
  final String deliverables;
  final String estimatedDuration;
  final String companyName;
  final String contactPerson;
  final String contactEmail;
  final String contactPhone;
  final String userName;
  final String statusName;
  final String tenderTitle;
  final List<BidDocumentModel> documents;
  final DateTime? creationDate;

  BidModel({
    required this.id,
    required this.title,
    required this.proposal,
    required this.totalPrice,
    required this.executionPlan,
    required this.deliverables,
    required this.estimatedDuration,
    required this.companyName,
    required this.contactPerson,
    required this.contactEmail,
    required this.contactPhone,
    required this.userName,
    required this.statusName,
    required this.tenderTitle,
    required this.documents,
    this.creationDate,
  });

  String get category => "General";
  String get deadline =>
      estimatedDuration.isNotEmpty ? estimatedDuration : "N/A";

  bool get isWinningBid => statusName.toLowerCase() == 'awarded';

  factory BidModel.fromJson(Map<String, dynamic> json) {
    var docList = <BidDocumentModel>[];
    if (json['documents'] != null) {
      docList = (json['documents'] as List)
          .map((item) => BidDocumentModel.fromJson(item))
          .toList();
    }

    return BidModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? 'Untitled Bid',
      proposal: json['proposal']?.toString() ?? '',
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
      executionPlan: json['execution_plan']?.toString() ?? '',
      deliverables: json['deliverables']?.toString() ?? '',
      estimatedDuration: json['estimated_duration']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      contactPerson: json['contact_person']?.toString() ?? '',
      contactEmail: json['contact_email']?.toString() ?? '',
      contactPhone: json['contact_phone']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      statusName: json['status_name']?.toString() ?? 'Pending',
      tenderTitle: json['tender_title']?.toString() ?? 'N/A',
      documents: docList,
      creationDate: json['creation_date'] != null
          ? DateTime.tryParse(json['creation_date'].toString())
          : null,
    );
  }
}

typedef Bid = BidModel;
