import 'package:flutter/material.dart';

class Item {
  String? itemGroup;
  String? itemName;
  String? itemCode;
  double itemPrice;
  String amount;
  TextEditingController qtyController;
  Item(
      {this.itemGroup,
      this.itemCode,
      this.itemName,this.amount='',
      this.itemPrice = 0.0,
      required this.qtyController});
}
