

class Invoice {
  String? invoice_id;
  String? customer;
  String? date;
  double amount;
  String? status;
  Invoice({
    required this.invoice_id,
  required this.customer,
    required this. date,
    required this.amount,
    required this.status
  });
}