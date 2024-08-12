// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/Leave/leave.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/Services/Preferences/preferences.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Provider_Leave extends ChangeNotifier {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController leavefromDateController = TextEditingController();
  TextEditingController leavetoDateController = TextEditingController();
  TextEditingController empNameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  // var fpicked, tpicked;
  bool isEmptyList = true;

  List<LeaveListModel> leaves = [];
  List leaveType = [
    'Leave Without Pay',
    'Privilege Leave',
    'Sick Leave',
    'Compensatory Off',
    'Casual Leave'
  ];
  String? selectedLeave;

  String? salesPerson;
  initialiseViewleaveDates({required BuildContext context}) async {
    empNameController.text =
        Provider.of<Provider_SalesPerson>(context, listen: false).name;
    selectedLeave = null;
    fromDateController.text = WaveFunctions().reverseDate(
      date: DateTime.now().toString().substring(0, 10),
    );
    toDateController.text = fromDateController.text;

    leavefromDateController.text = WaveFunctions().reverseDate(
        date: DateTime.now()
            .subtract(Duration(days: 30))
            .toString()
            .substring(0, 10));
    leavetoDateController.text = WaveFunctions()
        .reverseDate(date: DateTime.now().toString().substring(0, 10));
    await getLeaveList(context: context);
    await getLeaveTypes(context);
  }

  setSeletedLeave({required String leaveType}) {
    selectedLeave = leaveType;
    notifyListeners();
  }

  Future getLeaveList({
    required BuildContext context,
  }) async {
    var isApproved;
    var result = await Api().getLeaveList(context,
        fromdate: leavefromDateController.text,
        todate: leavetoDateController.text);
    leaves.clear();
    if (result != null) {
      if (result['success']) {
        result['message'].forEach((element) {
          if (element['status'] == 'Approved') {
            isApproved = true;
          } else {
            isApproved = false;
          }
          leaves.add(LeaveListModel(
              leaveType: element['leave_type'],
              leaveDate: element['from_date'],
              status: element['status'],
              isApproved: isApproved));
        });
      }
    }

    notifyListeners();
  }

  setToDateController({required String date}) {
    toDateController.text = date;
    notifyListeners();
  }

  setFromDateController({required String date}) {
    fromDateController.text = date;
    notifyListeners();
  }

  setleaveToDateController({required String date}) {
    leavetoDateController.text = date;
    // toDateController.text = date;
    notifyListeners();
  }

  setleaveFromDateController({required String date}) {
    leavefromDateController.text = date;
    notifyListeners();
  }

  Future getLeaveTypes(BuildContext context) async {
    var result = await Api().getLeaveType(context: context);
    if (result != null) {
      if (result['success']) {
        leaveType.clear();
        leaveType.addAll(result['leave_type']);
      }
    }
    // });
    notifyListeners();
  }

  void requestButtonPressed({
    required BuildContext context,
  }) async {
    salesPerson = await PrefernceData().getLogedSalesPerson();
    if (selectedLeave == null) {
      WavesWidgets()
          .snackBarError(context: context, message: 'Select a Leave Type');
      // EasyLoading.showToast('');
    } else {
      var result = await Api().leaveRequest(
          context: context,
          employee: salesPerson,
          leaveType: selectedLeave,
          reason: reasonController.text,
          fromDate: WaveFunctions().reverseDate(date: fromDateController.text),
          todate: WaveFunctions().reverseDate(date: toDateController.text));
      if (result != null) {
        if (result['success']) {
          selectedLeave = null;
          WavesWidgets().snackBarSuccess(
              context: context, message: '${result['message']}');
          await getLeaveList(context: context);
          Navigator.of(context).pop();
        }
        // else {
        //   if (result['error'].toString().contains(':')) {
        //     EasyLoading.showInfo(
        //         result['error']
        //             .toString()
        //             .substring(0, result['error'].toString().indexOf(':')),
        //         duration: Duration(seconds: 2));
        //   }
        else {
          WavesWidgets()
              .snackBarError(context: context, message: result['error']);
          // EasyLoading.showInfo(result['error'],
          // duration: Duration(seconds: 2));
        }
      }

      await getLeaveList(context: context);
    }
  }
}
