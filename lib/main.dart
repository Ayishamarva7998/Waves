import 'package:flutter/material.dart';
import 'package:waves/Services/DataBase/localdb.dart';
import 'package:waves/Services/Location/locationServices.dart';
import 'package:waves/Services/Preferences/preferences.dart';
import 'package:waves/waves.dart';

bool loginStatus=false;
void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
loginStatus=await PrefernceData().getLoginStatus();
  await LocalStorage().hiveInitialise();
  await LocationServices().getLocationPermission();
  runApp(const WavesApp());
}
