import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/History/salesorder.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';

class Provider_History extends ChangeNotifier {
  bool isLoading = false;
  SalesOrder? salesOrder;
  String? status;
  Future createInvoice(
      {required String customer, required BuildContext context}) async {
    setLoading();
    var result = await Api().createSalesInvoice(
        context: context,
        customer: customer,
        saleOrder: salesOrder!.salesOrderId);
    if (result != null) {
      if (result['success']) {
        WavesWidgets().snackBarSuccess(context: context, message: result['message']);
        Provider.of<Provider_Primary>(context, listen: false)
            .get_customer_OrderHistory(context: context);
        Navigator.of(context).pop();
      }
      //{success: true, message: Invoice Ceated SINV-23-00763}
    }
    finishLoading();
  }

  setLoading() {
    isLoading = true;
    notifyListeners();
  }

  finishLoading() {
    isLoading = false;
    notifyListeners();
  }
}