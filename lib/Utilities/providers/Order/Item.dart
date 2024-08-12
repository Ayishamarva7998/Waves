import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/Item/item.dart';
import 'package:waves/Models/DataBase/customerorderlist.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/Services/DataBase/localdb.dart';

import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Provider_Item extends ChangeNotifier {
  List<CustomerOrderList> hiveCustomerOrderList = [];
  List<CustomerOrderList> customerOrderList = [];
  late Box<CustomerOrderList> orderlist;
  List<Item> itemMaster = [];
  List<Tab> itemGroups = [];
  List<Item> itemList = []; ////////////////////////
  List<CustomerOrderList> editOrderList = [];
  TextEditingController itemSearch = TextEditingController();
  double totalAmount = 0;
  int oflineordercount = 0;
  late Provider_SalesPerson salesPerson;
  // late Secondary secondary;
  late Provider_Primary primary;
  initializeProviders({required BuildContext context}) {
    salesPerson = Provider.of<Provider_SalesPerson>(context, listen: false);
    // secondary = Provider.of<Secondary>(context, listen: false);
    primary = Provider.of<Provider_Primary>(context, listen: false);
  }

  getItemMaster({required BuildContext context}) async {
    Set groups = {};
    await Api().getItemList(context: context).then((value) {
      if (value != null) {
        if (value['success']) {
          itemMaster.clear();
          itemGroups.clear();
          value['item_list'].forEach((element) {
            itemMaster.add(
              Item(
                qtyController: TextEditingController(),
                itemGroup: element['item_group'],
                itemCode: element['item_code'],
                itemName: element['item_name'] ?? '',
                itemPrice: double.parse('${element['rate']}'),
              ),
            );
            groups.add(element['item_group']);
          });
          groups.forEach((element) {
            itemGroups.add(Tab(
              text: '${element}',
            ));
          });
          itemMaster.sort((a, b) => a.itemName!.compareTo(b.itemName!));
          notifyListeners();
        }
      }
    });
  }

  getItemByGroup({required String itemgroup, required ThemeData theme}) {
    itemList.clear();

    itemMaster.forEach((element) {
      if (element.itemGroup.toString().toLowerCase() ==
          itemgroup.toLowerCase()) {
        if (itemSearch.text == '') {
          itemList.add(element);
        } else {
          if (element.itemName!
              .toLowerCase()
              .contains(itemSearch.text.toLowerCase())) {
            itemList.add(element);
          }
        }
      }
    });
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      padding: EdgeInsets.all(10),
      itemCount: itemList.length,
      itemBuilder: (context, index) => Container(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${itemList[index].itemName}',
                        style: theme.textTheme.bodySmall!
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text('${itemList[index].itemCode}',
                        style: theme.textTheme.bodySmall),
                  ]),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
                child: Text('${itemList[index].itemPrice}',
                    style: theme.textTheme.bodySmall)),
            const Expanded(child: SizedBox()),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: theme.textTheme.bodySmall,
                controller: itemList[index].qtyController,
                decoration: InputDecoration(),
                onChanged: (v) {
                  notifyListeners();
                },
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
                child: Center(
                    child: Text(
              itemList[index].qtyController.text == ''
                  ? ''
                  : '${double.parse('${itemList[index].qtyController.text}') * itemList[index].itemPrice}',
              style: theme.textTheme.bodySmall,
            )))
          ],
        ),
      ),
    );
  }

  clearItemQty() {
    itemMaster.forEach((element) {
      element.qtyController!.clear();
    });
  }

  getoflineOrderCount() async {
    orderlist = await Hive.openBox<CustomerOrderList>('orderList');
    Set customers = {};
    List itemtodelete = [];
    // if (oflineordercount == 0) {
    int i = 0;
    orderlist.values.forEach((element) {
      if (element.isSubmitted == 3) {
        itemtodelete.add(i);
      }
      i++;
    });
    for (int n = itemtodelete.length - 1; n >= 0; n--) {
      await orderlist.deleteAt(itemtodelete[n]);
    }

    orderlist.values.forEach((element) {
      if (element.isSubmitted == 1) {
        customers.add(element.customercode);
      }
    });
    oflineordercount = customers.length;
    notifyListeners();
  }
  // getItemList() {
  //   itemList.clear();

  //   itemMaster.forEach((element) {
  //     element.qtyController.clear();
  //     itemList.add(element);
  //   });
  // }
  saveOflineOrders(
      {required String customerCode,
      required lattitude,
      required longitude}) async {
    orderlist = await Hive.openBox<CustomerOrderList>('orderList');
    int i = 0;
    orderlist.values.forEach((element) {
      if (element.customercode == customerCode) {
        orderlist.putAt(
            i,
            CustomerOrderList(
                amount: element.amount,
                customerName: element.customerName,
                customercode: element.customercode,
                isSubmitted: 1,
                itemCode: element.itemCode,
                itemName: element.itemCode,
                itemQty: element.itemQty,
                itemRate: element.itemRate,
                latitude: lattitude.toString(),
                salesPerson: element.salesPerson,
                longitude: longitude.toString()));
        // orderlist. values.elementAt(i).isSubmitted = 1;
        // orderlist.values.elementAt(i).latitude = lattitude.toString();
        // orderlist.values.elementAt(i).longitude = longitude.toString();
      }
      i++;
    });
  }

  Future syncoflineData() async {
    log('ofline ${DateTime.now()}');
    await Hive.initFlutter();
    await LocalStorage().hiveInitialise();
    try {
      orderlist = await Hive.openBox<CustomerOrderList>('orderList');

      Set customers = {};
      List itemList = [];

      orderlist.values.forEach((element) {
        if (element.isSubmitted == 1) {
          customers.add(element.customercode);
        }
      });
      log('$customers');
      customers.forEach((customer) async {
        var latitude, longitude;
        orderlist.values.forEach((element) {
          if (element.customercode == customer && element.isSubmitted == 1) {
            itemList.add({
              "item_code": element.itemCode,
              "quantity": element.itemQty,
              "rate": element.itemRate
            });
            latitude = element.longitude;
            longitude = element.latitude;
          }
        });
        // var result =
        await Api()
            .syncOrder(
                latitude: latitude,
                longitude: longitude,
                customer: customer,
                itemlist: itemList)
            .then((value) => log('$value'));
        await getoflineOrderCount();
        // return result;
      });
    } catch (e) {
      log('$e');
    }
    await getoflineOrderCount();
  }

  Future getCustomerOrderList({required BuildContext context}) async {
    // customerName = await SharedStorage().getCustomerName();
    String? customerName, customer_Code;
    orderlist = await Hive.openBox<CustomerOrderList>('orderList');
    // hiveCustomerOrderList=orderlist.values;
    await initializeProviders(context: context);
    customerOrderList.clear();
    // await LocalStorage()
    //     .getCustomerOrderList()
    //     .then((value) => hiveCustomerOrderList);
    customerName = primary.selectedCustomerName;
    customer_Code = primary.selectedCustomerCode;
    // initializeProviders(context: context);
    String? shopName;
    // if (salesPerson.orderType == 0) {
    // shopName = secondary.shopCode;
    // customerName = secondary.selectedDistributor!;
    // }
    // if (salesPerson.orderType == 1) {
    //   shopName = null;
    // customerName = primary.selectedDistributor!;
    // customer_Code = primary.selectedCustomerCode!;
    // }
    orderlist.values.forEach((element) {
      if (element.salesPerson == salesPerson.name) {
        if (element.customercode == customer_Code &&
            element.isSubmitted == 0 &&
            element.customerName == customerName) {
          customerOrderList.add(element);
        }
        // if (element.orderType == 1 && element.customercode == customer_Code) {
        //   customerOrderList.add(element);
        // }
      }
    });
    getTotalAmount();
    // print(hiveCustomerOrderList);
    // notifyListeners();
  }

  decrementItemCountFromCustomerList(
      {required int index,
      required BuildContext context,
      required String customerName}) async {
    initializeProviders(context: context);
    if (customerOrderList[index].itemQty == 1) {
      deleteItemFromCustomerOrder(
          index: index, context: context, customerName: customerName);
    } else {
      customerOrderList[index].itemQty = customerOrderList[index].itemQty! - 1;
      customerOrderList[index].amount = customerOrderList[index].itemQty! *
          customerOrderList[index].itemRate!;
      hiveCustomerOrderList.forEach((element) {
        if (element.orderType == salesPerson.orderType &&
            element.customerName == customerName &&
            element.itemCode == customerOrderList[index].itemCode) {
          // if (element.orderType == 0 &&
          //     element.shopcode == secondary.shopCode) {
          //   element.itemQty = customerOrderList[index].itemQty;
          //   element.amount = customerOrderList[index].amount;
          // }
          // if (element.orderType == 1) {

          element.itemQty = customerOrderList[index].itemQty;
          element.amount = customerOrderList[index].amount;
          // }
        }
      });
      for (var item in itemList) {
        if (item.itemCode == customerOrderList[index].itemCode) {
          item.qtyController.text =
              '${customerOrderList[index].itemQty!.toInt()}';
        }
      }
    }
    getTotalAmount();
    notifyListeners();
  }

  getEditOrderList() {}

  void deleteItemFromCustomerOrder(
      {required int index,
      required BuildContext context,
      required String customerName}) async {
    initializeProviders(context: context);
    int i = 0;
    int indextodelete = -1;
    for (var item in itemList) {
      if (item.itemCode == customerOrderList[index].itemCode) {
        item.qtyController.clear();
      }
    }
    for (var element in hiveCustomerOrderList) {
      if (element.orderType == salesPerson.orderType &&
          element.customerName == customerName &&
          element.itemCode == customerOrderList[index].itemCode) {
        // if (element.orderType == 0 && element.shopcode == secondary.shopCode) {
        //   indextodelete = i;
        // }
        // if (element.orderType == 1) {
        indextodelete = i;
        break;
        // }
      }
      i++;
    }
    if (indextodelete != -1) {
      hiveCustomerOrderList.removeAt(indextodelete);
    }
    customerOrderList.removeAt(index);
    if (customerOrderList.isEmpty) {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  void incrementItemCountFromCustomerList(
      {required int index, required String customerName}) {
    customerOrderList[index].itemQty = customerOrderList[index].itemQty! + 1;
    customerOrderList[index].amount =
        customerOrderList[index].itemQty! * customerOrderList[index].itemRate!;
    hiveCustomerOrderList.forEach((element) {
      if (element.orderType == salesPerson.orderType &&
          element.customerName == customerName &&
          element.itemCode == customerOrderList[index].itemCode) {
        // if (element.orderType == 0 && element.shopcode == secondary.shopCode) {
        //   element.itemQty = customerOrderList[index].itemQty;
        //   element.amount = customerOrderList[index].amount;
        // }
        if (element.orderType == 1) {
          element.itemQty = customerOrderList[index].itemQty;
          element.amount = customerOrderList[index].amount;
        }
      }
    });
    for (var item in itemList) {
      if (item.itemCode == customerOrderList[index].itemCode) {
        item.qtyController.text =
            '${customerOrderList[index].itemQty!.toInt()}';
      }
    }
    getTotalAmount();
    notifyListeners();
  }

  getTotalAmount() {
    totalAmount = 0;
    customerOrderList.forEach((element) {
      totalAmount = totalAmount + element.amount!;
    });
  }

  clearCustomerOrder({required customerCode}) async {
    int i = -1;
    List itemstodelete = [];
    orderlist = await Hive.openBox<CustomerOrderList>('orderList');
    orderlist.values.forEach((element) {
      i++;
      if (element.customercode == customerCode) {
        itemstodelete.add(i);
      }
    });

    for (int x = itemstodelete.length; x > 0; x--) {
      // int j = itemstodelete.length - x - 1;
      // int y = itemstodelete[j];
      orderlist.deleteAt(x - 1);
    }
  }

  Future addbuttonPressed({required BuildContext context}) async {
    // isLoading.value = true;
    Provider_SalesPerson salesPerson =
        Provider.of<Provider_SalesPerson>(context, listen: false);
    Provider_Primary primary =
        Provider.of<Provider_Primary>(context, listen: false);
    orderlist = await Hive.openBox<CustomerOrderList>('orderList');
    String? shopName;
    String? customerName;
    String? customercode;
    ////////////////////
    try {
      // if (salesPerson.orderType == 0) {
      //   shopName = secondary.shopName!;
      //   customercode = secondary.shopCode;
      //   customerName = secondary.selectedDistributor;
      // }
      // if (salesPerson.orderType == 1) {
      customercode = primary.selectedCustomerCode;
      customerName = primary.selectedCustomerName;
      // }
      ////////////////////

      if (orderlist.isEmpty) {
        itemList.forEach((element) async {
          if (element.qtyController!.text != '') {
            if (double.parse(element.qtyController!.text) != 0) {
              orderlist.add(
                CustomerOrderList(
                  orderType: salesPerson.orderType,
                  amount: (element.itemPrice *
                      double.parse(element.qtyController.text)),
                  shopcode: customercode,
                  shopName: customerName,
                  salesPerson: salesPerson.name,
                  customercode: customercode,
                  customerName: customerName,
                  itemQty: double.parse(element.qtyController.text),
                  itemCode: element.itemCode,
                  itemName: element.itemName,
                  itemRate: element.itemPrice,
                ),
              );
            }
          }
        });
      } else {
        itemList.forEach(
          (item) {
            var isItempresent = false;
            if (item.qtyController.text != '') {
              if (double.parse(item.qtyController.text) != 0) {
                orderlist.values.forEach((element) {
                  if (element.customercode == customercode &&
                      element.customerName == customerName &&
                      item.itemCode == element.itemCode) {
                    isItempresent = true;
                    if (element.itemQty !=
                        double.parse(item.qtyController.text)) {
                      element.itemQty = double.parse(item.qtyController.text);
                    }
                  }
                });
                if (!isItempresent) {
                  orderlist.add(
                    CustomerOrderList(
                      orderType: salesPerson.orderType,
                      amount: (item.itemPrice *
                          double.parse(item.qtyController.text)),
                      shopcode: customercode,
                      shopName: customerName,
                      customerName: customerName,
                      salesPerson: salesPerson.name,
                      customercode: customercode,
                      itemQty: double.parse(item.qtyController.text),
                      itemCode: item.itemCode,
                      itemName: item.itemName,
                      itemRate: item.itemPrice,
                    ),
                  );
                }
              }
            }
          },
        );
      }
      await getCustomerOrderList(context: context);

      notifyListeners();

      //  Provider.of<ItemData>(context, listen: false).isSubmitted = 1;
    }
    //  on SocketException catch (e) {
    //   Provider.of<ItemData>(context, listen: false).isSubmitted = 0;

    //   // Save to hiveCustomerOrderList whn offline
    //   itemList.forEach((element) async {
    //     if (element.qtyController!.text != '') {
    //       hiveCustomerOrderList.add(
    //         CustomerOrderList(
    //           orderType: salesPerson.orderType,
    //           amount: (element.itemPrice *
    //               double.parse(element.qtyController!.text)),
    //           shopcode: customercode,
    //           shopName: secondary.shopName,
    //           salesPerson: salesPerson.name,
    //           customercode: customercode,
    //           customerName: customerName,
    //           itemQty: double.parse(element.qtyController!.text),
    //           itemCode: element.itemCode,
    //           itemName: element.itemName,
    //           itemRate: element.itemPrice,
    //         ),
    //       );
    //     }
    //   });

    //   return;
    // }
    catch (e) {
      // isLoading.value = false;
    }
  }
}
