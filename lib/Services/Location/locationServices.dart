import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationServices extends ChangeNotifier {
  late Location location;
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;
  late bool isLocationOn;
  double? latitude;
  double? longitude;

  getLocationPermission() async {
    location = Location();
    isLocationOn = await Geolocator.isLocationServiceEnabled();
    if (!isLocationOn) {
      Geolocator.openLocationSettings();
    }
    if (isLocationOn) {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    }
  }

  watchuserLocation() async {
    await getLocationPermission();
    location.onLocationChanged.listen((event) {
      latitude = event.latitude;
      longitude = event.longitude;
    });
    notifyListeners();
  }

  stopWatchingUserLocation() async {
    await getLocationPermission();
    location.onLocationChanged.listen((event) {}).cancel();
  }
}
