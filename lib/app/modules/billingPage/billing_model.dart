class BillingInvoice {
  final int tenderId;
  final String tenderTitle;
  final String category;
  final double amount;
  final String paymentStatus;
  final String? paymentMethod;
  final String? paymentReference;
  final DateTime? paymentDate;
  final bool hasActiveInvoice;

  BillingInvoice({
    required this.tenderId,
    required this.tenderTitle,
    required this.category,
    required this.amount,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentReference,
    this.paymentDate,
    required this.hasActiveInvoice,
  });

  factory BillingInvoice.fromJson(Map<String, dynamic> json) {
    final bool hasPayment = json['payment'] != null;
    final paymentData = json['payment'] ?? {};

    return BillingInvoice(
      tenderId: json['id'] as int,
      tenderTitle: json['title'] ?? '',
      category: json['category'] is Map ? (json['category']['name'] ?? '') : '',
      amount:
          double.tryParse(paymentData['amount']?.toString() ?? '100.00') ??
          100.00,
      paymentStatus: paymentData['payment_status'] ?? 'Pending',
      paymentMethod: paymentData['payment_method'] ?? 'Sham Cash',
      paymentReference: paymentData['payment_reference'],
      paymentDate: paymentData['payment_date'] != null
          ? DateTime.tryParse(paymentData['payment_date'])
          : null,
      hasActiveInvoice: hasPayment,
    );
  }
}
