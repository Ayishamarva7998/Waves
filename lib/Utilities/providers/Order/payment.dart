import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';

class Provider_Payment extends ChangeNotifier {
  List paymodes = ['Cheque', 'Cash', 'UPI', 'Card'];

  TextEditingController paymentDateController = TextEditingController();

  TextEditingController checkdateController = TextEditingController();

  TextEditingController paymentAmount = TextEditingController();

  TextEditingController referenceController = TextEditingController();

  String? selectedPayment;

  bool isAmountErrorNotifier = false;
  bool isLoading = false;
  bool isReferenceErrorNotifier = false;

  setPaymentdefault({required BuildContext context}) async {
    var date = DateTime.now().toString().substring(0, 10);
    paymentDateController.text = WaveFunctions().reverseDate(date: date);
    checkdateController.text = WaveFunctions().reverseDate(date: date);

    await getPaymentModes(context: context);
    paymentAmount.text = '';
    selectedPayment = null;
    isReferenceErrorNotifier = false;
    isAmountErrorNotifier = false;
  }

  setPaymentMode({required String mode}) {
    selectedPayment = mode;
    notifyListeners();
  }

  setPaymentdate({required String date}) {
    paymentDateController.text = date;
    notifyListeners();
  }

  setLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  setCheckdate({required String date}) {
    checkdateController.text = date;
    notifyListeners();
  }

  Future getPaymentModes({required BuildContext context}) async {
    selectedPayment = null;
    var result = await Api().getPaymentModes(context: context);
    if (result != null) {
      if (result['success']) {
        paymodes.clear();
        for (var i in result['Mode of Payment']) {
          paymodes.add(i['name']);
        }
      }
    }
    notifyListeners();
  }

  paymentButtonPressed({required BuildContext context}) async {
    if (selectedPayment == 'Cheque' &&
        referenceController.text.isEmpty &&
        paymentAmount.text.isEmpty) {
      isReferenceErrorNotifier = true;
      isAmountErrorNotifier = true;
    } else {
      isReferenceErrorNotifier = false;

      if (paymentAmount.text.isEmpty) {
        isAmountErrorNotifier = true;
      } else {
        isAmountErrorNotifier = false;
        isReferenceErrorNotifier = true;
      }

      if (selectedPayment == null || selectedPayment!.isEmpty) {
        WavesWidgets().snackBarError(
            context: context, message: "Please select a payment mode.");
      }
      if (selectedPayment != 'Cash' &&
          selectedPayment != 'Card' &&
          selectedPayment != 'UPI' &&
          referenceController.text.isEmpty) {
        isReferenceErrorNotifier = true;
      } else {
        isReferenceErrorNotifier = false;
      }
      if (!isAmountErrorNotifier && !isReferenceErrorNotifier) {
        setLoading();
        Provider_Primary primary =
            Provider.of<Provider_Primary>(context, listen: false);
        Provider_Payment payment =
            Provider.of<Provider_Payment>(context, listen: false);
        var result = await Api().createPayment(
          source: '',
          context: context,
          sales_person: '',
          customer: primary.selectedCustomerCode!,
          mode: selectedPayment,
          paid_amount: paymentAmount.text,
        );
        if (result['success']) {
          await primary.getCustomerCredits(context: context);
          WavesWidgets()
              .snackBarSuccess(context: context, message: result['message']);
          Navigator.of(context).pop();
        } else {
          WavesWidgets()
              .snackBarError(context: context, message: result['message']);
        }
        stopLoading();
      }
    }
  }
}
