import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waves/Models/DataBase/customerorderlist.dart';
import 'package:waves/UI/screens/loginScreen/loginsreen.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/landingpage/landing.dart';

class LocalStorage {
  late SharedPreferences preferences;
  final storage = const FlutterSecureStorage();

  Future initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future logout(BuildContext context) async {
    preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    await storage.delete(key: 'SecureKey');

    await preferences.remove('SalesPerson');
    Provider.of<Provider_Primary>(context, listen: false)
        .setSelectedRoute(route: null, context: context);
    await saveLoginStatus(false);
    Provider.of<Provider_Landing>(context, listen: false).index = 0;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Screen_Login()));
  }

  Future deleteLogedSalesPerson() async {
    await initializePreference();
    await preferences.remove('SalesPerson');
  }

  Future saveLoginStatus(bool loginStatus) async {
    await initializePreference();
    await preferences.setBool('Login', loginStatus);
  }

  Future hiveInitialise() async {
    await Hive.initFlutter();
    // if (!Hive.isAdapterRegistered(UserLocationAdapter().typeId)) {
    //   Hive.registerAdapter(UserLocationAdapter());
    // }

    // await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(CustomerOrderListAdapter().typeId)) {
      Hive.registerAdapter(CustomerOrderListAdapter());
    }
    // if (!Hive.isAdapterRegistered(ShopAdapter().typeId)) {
    //   Hive.registerAdapter(ShopAdapter());
    // }
  }

  Future getCustomerOrderList() async {
    Box<CustomerOrderList> hiveCustomerOrderList =
        await Hive.openBox<CustomerOrderList>('customer_order_Table');
    return hiveCustomerOrderList;
  }

  // Future getShopList() async {
  //   Box<Shop> hiveShopList = await Hive.openBox<Shop>('shop_Table');
  //   return hiveShopList;
  // }

  // saveLocation({
  //   required String latitude,
  //   required String longitude,
  // }) async {
  //   Box<UserLocation> locationList =
  //       await Hive.openBox<UserLocation>('user_locations');
  //   locationList.add(UserLocation(
  //       date: reverseDate(date: DateTime.now().toString().substring(0, 10)),
  //       latitude: latitude,
  //       longitude: longitude));
  //   Hive.close();
  // }
}
