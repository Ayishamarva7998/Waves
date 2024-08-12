import 'package:waves/Models/Data/Customer/CustomerOrderDetails.dart';

class InvoiceData {
  String? invoice_id;
  String? invoiceDate;
  String? customer;
  String? invoiceAmount;
  String? outstanding_amount;
  List<CustomerOrder>? items = [];
  InvoiceData({
    this.invoice_id,
    this.customer,
    this.invoiceDate,
    this.outstanding_amount = '0',
    this.invoiceAmount,
    this.items,
  });
}
