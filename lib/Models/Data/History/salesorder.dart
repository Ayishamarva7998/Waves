class SalesOrder {
  String? salesOrderId;
  String? salesOrderStatus;
  String? salesOrderDate;
  String? delivery_date;
  double? amount;
  SalesOrder(
      {this.salesOrderDate,
      this.amount,
      this.delivery_date,
      this.salesOrderId,
      this.salesOrderStatus});
}
