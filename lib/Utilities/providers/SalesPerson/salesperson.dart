import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/Services/Preferences/preferences.dart';

class Provider_SalesPerson extends ChangeNotifier {
  String name = '';
  int? userType;
  int? orderType;
  int? attendanceStatus;
  int? checkinStatus;
  String? userName;
  getSalesPerson() async {
    name = await  PrefernceData().getLogedSalesPerson();
    // this.userType = await prefernceData()().getUserType();
    notifyListeners();
  }
}
