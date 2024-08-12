import 'package:flutter/material.dart';

class Provider_Landing extends ChangeNotifier {
  final controller = ScrollController();
  int index = 0;
  setIndex({required int num}) {
    index = num;
    notifyListeners();
  }
}
