class CustomerOrderHistory {
  final String? name;
  final String? orderDate;
  final double? amount;
  final double? balance;
  final String? distributor;
  final String? status;
  final double? advance_paid;

  CustomerOrderHistory(
      {required this.name,
      required this.orderDate,
      required this.amount,
      required this.status,
      required this.distributor,
      required this.advance_paid,
      required this.balance});
}
