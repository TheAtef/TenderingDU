class SubmitBidModel {
  final int tenderId;
  final double bidAmount;
  final String currency;
  final String executionPlan;
  final String duration;
  final String bidderName;
  final String email;
  final String phone;
  final bool agreedTerms;

  SubmitBidModel({
    required this.tenderId,
    required this.bidAmount,
    required this.currency,
    required this.executionPlan,
    required this.duration,
    required this.bidderName,
    required this.email,
    required this.phone,
    required this.agreedTerms,
  });

  Map<String, dynamic> toJson() => {
    'tender_id': tenderId,
    'bid_amount': bidAmount,
    'currency': currency,
    'execution_plan': executionPlan,
    'duration': duration,
    'bidder_name': bidderName,
    'email': email,
    'phone': phone,
    'agreed_terms': agreedTerms,
  };
}
