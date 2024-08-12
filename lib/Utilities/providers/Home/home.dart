import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Location/geolocation.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Provider_Home extends ChangeNotifier {
  bool isLoading = false;
  String salesPerson = '';
  int attendance = 0;
  int? userType;

  Future getAttendanceStatus({required BuildContext context}) async {
    isLoading = true;
    Provider_SalesPerson person =
        Provider.of<Provider_SalesPerson>(context, listen: false);
    await person.getSalesPerson();
    salesPerson = person.name;
    userType = person.userType;
    // notifyListeners();
    await Provider.of<Provider_SalesPerson>(context, listen: false)
        .getSalesPerson();

    await Api().getAttendanceStatus(context: context).then((value) async {
      if (value != null) {
        if (value['status']) {
          attendance = value['attendance'];
          // notifyListeners();
          // if (attendance > 0) {
          // await Workmanager()
          //     .initialize(callbackDispatcher, isInDebugMode: true);
          // Provider.of<Provider_map>(context, listen: false)
          //     .schedulePeriodicTask();
          // }
        }
      }
    });
    // isLoading = false;
    notifyListeners();
  }

  Future checkIn({required BuildContext context}) async {
    // CheckInData checkin = CheckInData();
    try {
      bool isLocationOn = await Geolocator.isLocationServiceEnabled();
      if (!isLocationOn) {
        isLocationOn = await Geolocator.openLocationSettings();
      }
      if (isLocationOn) {
        try {
          await GeoLocation().determinePosition();
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          var address = await GeoLocation().GetAddressFromLatLong(position);
          await Api()
              .markAttendence(context, checkOut: address)
              .then((value) async {
            if (value != null) {
              if (value['success']) {
              } else {
                WavesWidgets()
                    .snackBarError(context: context, message: value['message']);
              }
              await getAttendanceStatus(context: context);
              notifyListeners();
            }
          });
        } catch (e) {
          log('$e');
        }
      }
    } catch (e) {
      log('$e');
    }
  }
}
