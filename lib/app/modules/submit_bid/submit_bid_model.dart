class SubmitBidModel {
  final int tenderId;
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

  SubmitBidModel({
    required this.tenderId,
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
  });

  Map<String, dynamic> toJson() => {
    'tender': tenderId,
    'title': title,
    'proposal': proposal,
    'total_price': totalPrice,
    'execution_plan': executionPlan,
    'deliverables': deliverables,
    'estimated_duration': estimatedDuration,
    'company_name': companyName,
    'contact_person': contactPerson,
    'contact_email': contactEmail,
    'contact_phone': contactPhone,
  };
}
