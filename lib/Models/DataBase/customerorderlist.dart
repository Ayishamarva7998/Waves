import 'package:hive_flutter/hive_flutter.dart';
part 'customerorderlist.g.dart';

@HiveType(typeId: 0)
class CustomerOrderList {
  @HiveField(0)
  int? orderType;

  @HiveField(1)
  String? shopName;

  @HiveField(2)
  String? shopcode;

  @HiveField(3)
  String? customerName;

  @HiveField(4)
  String? customercode;

  @HiveField(5)
  String? itemCode;

  @HiveField(6)
  String? itemName;

  @HiveField(7)
  double? itemQty;

  @HiveField(8)
  double? itemRate;

  @HiveField(9)
  double? amount;

  @HiveField(10)
  String? longitude;

  @HiveField(11)
  String? latitude;

  @HiveField(12)
  String? salesPerson;
  @HiveField(12)
  int isSubmitted;

  CustomerOrderList({
    this.orderType,
    this.shopName,
    this.shopcode,
    this.customerName,
    this.customercode,
    this.itemCode,
    this.itemName,
    this.itemQty,
    this.isSubmitted = 0,
    this.itemRate,
    this.amount,
    this.longitude,
    this.latitude,
    this.salesPerson,
  });
}
