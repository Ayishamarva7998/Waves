class InvoiceHistory {
  final String? name;
  final String? posting_date;
  final double? total;

  final String? customer;
  final String? status;

  InvoiceHistory({
    required this.name,
    required this.posting_date,
    required this.total,
    required this.status,
    required this.customer,
  });
}
