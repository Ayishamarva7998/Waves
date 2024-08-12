import 'package:waves/Models/Data/Customer/CustomerOrderDetails.dart';

class SalesOrderData {
  String? sales_order_id;
  String? sales_orderDate;
  String? advance_paid;
  double balance;
  String? customer;
  String? delivery_date;
  String? status;
  String? sales_orderAmount;
  List<CustomerOrder>? items = [];
  SalesOrderData({
    this.sales_order_id,
    this.balance = 0,
    this.delivery_date,
    this.status,
    this.advance_paid = '0',
    this.customer,
    this.sales_orderDate,
    this.sales_orderAmount,
    this.items,
  });
}
