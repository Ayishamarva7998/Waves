import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/Services/Preferences/preferences.dart';
import 'package:waves/UI/screens/landingScreen/landing_page.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';
import 'package:waves/Utilities/providers/landingpage/landing.dart';

class Provider_Login extends ChangeNotifier {
  bool isLoading = false;
  bool view_Password = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  setLoading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  setViewPassword() {
    view_Password = !view_Password;
    notifyListeners();
  }

  Future loginButtonPressed({required BuildContext context}) async {
    setLoading();

    var result = await Api().authenticate(
        context: context,
        username: usernameController.text,
        password: passwordController.text);
    if (result != null) {
      if (result['success']) {
        await PrefernceData().savetoken(token: result['token']);
        await PrefernceData()
            .saveLogedSalesPerson(name: result['sales_person']);
        WavesWidgets()
            .snackBarSuccess(context: context, message: result['message']);
        await PrefernceData().saveLoginStatus(loginStatus: true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Screen_Landing()));
      } else {
        WavesWidgets()
            .snackBarError(context: context, message: result['message']);
      }
    } else {
      WavesWidgets().snackBarError(context: context, message: 'NetWork Errror');
    }
    stopLoading();
  }
}
//{success: true, message: Logged In Succesfully, token: ZWQ5YWI2ZGRjNDIyMGQ3OmJmYjA4Y2QxNjNhYjFkMQ==, sales_person: Rahul}