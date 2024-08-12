import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waves/Models/Data/Attendance/attendanceModel.dart';

class GeoLocation extends ChangeNotifier {
  bool storageServivceEnabled = false;
  bool mediaServivceEnabled = false;
  bool locationServivceEnabled = false;
  PermissionStatus? permission;
  LocationPermission? status;
  getStoragePermission() async {
    storageServivceEnabled = await Permission.storage.isGranted;
    if (!storageServivceEnabled) {
      await Permission.storage.request();
      // return Future.error('Storage Permission Denaid');
    }
    permission = await Permission.storage.status;
    if (permission == Permission.storage.isDenied) {
      permission = await Permission.storage.request();
      if (permission == Permission.storage.isDenied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Storage permissions are denied');
      }
    }

    if (permission == Permission.storage.isPermanentlyDenied) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Storage permissions are permanently denied, we cannot request permissions.');
    }
  }

  getMediaPermission() async {
    // bool servivceEnabled;
    PermissionStatus permission;
    mediaServivceEnabled = await Permission.accessMediaLocation.isGranted;
    if (!mediaServivceEnabled) {
      await Permission.accessMediaLocation.request();
      // return Future.error('Storage Permission Denaid');
    }
    permission = await Permission.accessMediaLocation.status;
    if (permission == Permission.accessMediaLocation.isDenied) {
      permission = await Permission.accessMediaLocation.request();
      if (permission == Permission.accessMediaLocation.isDenied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('MediaLocation permissions are denied');
      }
    }

    if (permission == Permission.storage.isPermanentlyDenied) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Storage permissions are permanently denied, we cannot request permissions.');
    }
  }

  checkPermission() async {
    // Test if location services are enabled.
    locationServivceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServivceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

// Getting Location Permission from user
  Future determinePosition() async {
    locationServivceEnabled = await Geolocator.isLocationServiceEnabled();
    // var location
    if (locationServivceEnabled) {
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
      // LocalStorage().saveLocation(
      //     latitude: location.latitude.toString(),
      //     longitude: location.longitude.toString());
      // if (!AppValues.istripended && AppValues.istripStarterd) {
      //   Future.delayed(Duration(seconds: 10))
      //       .then((value) => determinePosition());
      // }
      // return location;
    } else {
      if (permission != LocationPermission.deniedForever) {
        // Test if location services are enabled.
        locationServivceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!locationServivceEnabled) {
          // Location services are not enabled don't continue
          // accessing the position and request users of the
          // App to enable the location services.
          return Future.error('Location services are disabled.');
        }

        status = await Geolocator.checkPermission();
        if (status == LocationPermission.denied) {
          status = await Geolocator.requestPermission();
          if (status == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            return Future.error('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }
      }
    }
  }

  Future GetAddressFromLatLong(Position position) async {
    List placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[2];
    CheckInData checkOutList = CheckInData();
    checkOutList.district = place.subAdministrativeArea;
    checkOutList.postalCode = place.postalCode;
    checkOutList.latitude = position.latitude.toString();
    checkOutList.longitude = position.longitude.toString();
    checkOutList.route = place.street;
    return checkOutList;
  }
}
