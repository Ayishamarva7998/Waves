import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefernceData {
  late SharedPreferences preferences;
  initializeSharePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _storage = const FlutterSecureStorage();
  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
 

  Future savetoken({required token}) async {
    _storage.write(
      key: 'SecureKey',
      value: token,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future getToken() async {
    var securekey = _storage.read(
      key: 'SecureKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return securekey;
  }

  Future deleteToken() async {
    _storage.delete(
      key: 'SecureKey',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  //saving and getting users login status from sharedpreferences
  Future saveLoginStatus({required bool loginStatus}) async {
    await initializeSharePreferences();
    await preferences.setBool('Login', loginStatus);
  }

  Future getLoginStatus() async {
    await initializeSharePreferences();
    bool login = preferences.getBool('Login') ?? false;
    return login;
  }

// saving  and getting loged Sales person Name
  Future saveLogedSalesPerson({required String name}) async {
    await initializeSharePreferences();
    await preferences.setString('SalesPerson', name);
  }

  Future getLogedSalesPerson() async {
    await initializeSharePreferences();
    String? name = preferences.getString('SalesPerson') ?? '';
    return name;
  }

}
