// A small model to handle the nested documents
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
      fileUrl: json['file'] ?? '', // Django returns the URL in the 'file' key
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
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
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

      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => BidDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
