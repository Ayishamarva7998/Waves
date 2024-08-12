

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waves/Models/Data/History/invoice.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';

class Provider_Invoice extends ChangeNotifier {
  List<InvoiceHistory> salespersonInvoicelist = [];
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  bool isLoading = false;
  getinvoicedefaults() {
    setisLoading();
    fromdate.text = WaveFunctions().reverseDate(
        date: DateTime.now()
            .subtract(Duration(days: 30))
            .toString()
            .substring(0, 10));
    todate.text = WaveFunctions()
        .reverseDate(date: DateTime.now().toString().substring(0, 10));
    stopisLoading();
  }

  setisLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopisLoading() {
    isLoading = false;
    notifyListeners();
  }

  setfromdate({required String date}) {
    fromdate.text = WaveFunctions().reverseDate(date: date);
    notifyListeners();
  }

  settodate({required String date}) {
    todate.text = WaveFunctions().reverseDate(date: date);
    notifyListeners();
  }

  getSalesPersonInvoiceList({required BuildContext context}) async {
    setisLoading();
    salespersonInvoicelist.clear();
    var result = await Api().getSalesPersonInvoices(context: context);
    if (result != null) {
      if (result['success']) {
        result['history'].forEach((element) {
          salespersonInvoicelist.add(InvoiceHistory(
              customer: element['customer'],
              name: element['name'],
              posting_date: element['posting_date'],
              status: element['status'],
              total: element['grand_total']));
        });
      }
    }
    stopisLoading();
  }
}
