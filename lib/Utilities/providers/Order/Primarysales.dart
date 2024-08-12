import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/Customer/CustomerOrderDetails.dart';
import 'package:waves/Models/Data/Customer/customer.dart';
import 'package:waves/Models/Data/Customer/salesorderView.dart';
import 'package:waves/Models/Data/History/customerorderHistory.dart';
import 'package:waves/Models/Data/History/invoice.dart';
import 'package:waves/Models/Data/Invoice/invoicedetails.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/Services/Location/locationServices.dart';
import 'package:waves/UI/screens/Order/invoiceDetails.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/UI/widgets/Order/ViewInvoice.dart';
import 'package:waves/UI/widgets/Order/ViewSalesOrder.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';

class Provider_Primary extends ChangeNotifier {
  bool isLoading = false;
  List invoiceHistoryList = [];
  List customerOrderHistoryList = [];
  List<Customer> customerMaster = [];
  String? salesOrderID, invoiceID;
  double outstandingAmount = 0;
  double creditLimit = 0;
  double creditBalance = 0;
  InvoiceData invoiceDetails = InvoiceData();
  TextEditingController amountController = TextEditingController();

  ValueNotifier<String?> selectedPayment = ValueNotifier(null);

  String? reportUrl;
  double? total;
  List routes = [];
  String? selectedRoute;
  String? selectedCustomerName;
  String? selectedCustomerCode;
  List<Customer> routeCustomers = [];
  // List<DistributorOrder> itemList = [];
  List<InvoiceDetails> invoiceList = [];
  SalesOrderData salesOrderDetails = SalesOrderData();

  TextEditingController fromdateController = TextEditingController();
  TextEditingController todateController = TextEditingController();
  // TextEditingController todateController1 = TextEditingController();
  setSelectedCustomer({required String name, required String code}) {
    selectedCustomerCode = code;
    selectedCustomerName = name;
    notifyListeners();
  }

  getRouteList({required BuildContext context}) async {
    setLoading();
    routes.clear();
    var result = await Api().getRoutes(context: context);
    if (result != null) {
      if (result['success']) {
        for (var item in result['routes']) {
          routes.add(item['name']);
        }
      }
    }
    finishLoading();
  }

  getCustomerList({required BuildContext context}) async {
    setLoading();
    customerMaster.clear();
    var result = await Api().getCustomers(
      context: context,
      route: selectedRoute.toString(),
    );
    if (result != null) {
      if (result['success']) {
        result['customer_list'].forEach((element) {
          customerMaster.add(Customer(
              customer: element['customer'],
              contact: element['mobile_no'] ?? '+91 XXXXXXXXXX',
              customer_code: element['distributor_code'],
              salesPerson: element['sales_person']));
        });
        // getExecutiveList();
      }
    }
    finishLoading();
  }

  setLoading() {
    isLoading = true;
    notifyListeners();
  }

  finishLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future setSelectedRoute(
      {String? route, required BuildContext context}) async {
    selectedRoute = route;
    if (route != null) {
      await getCustomerList(context: context);
    } else {
      customerMaster.clear();
    }
    notifyListeners();
  }

  // getExecutiveList() {
  //   Set salesPersons = {};
  //   for (var customer in customerMaster) {
  //     salesPersons.add(customer.salesPerson);
  //   }
  //   routes.clear();
  //   routes.addAll(salesPersons.toList());
  //   notifyListeners();
  // }

  // getRouteCustomer({String? route}) {
  //   route ??= selectedRoute;
  //   routeCustomers.clear();
  //   for (var customer in customerMaster) {
  //     if (customer.salesPerson == executive) {
  //       executiveCustomers.add(customer);
  //     }
  //   }
  //   notifyListeners();
  // }

  createSalesOrder({required BuildContext context}) async {
    setLoading();

    await Provider.of<LocationServices>(context, listen: false)
        .stopWatchingUserLocation();
    var result = await Api().placeSalesOrder(context: context);
    if (result != null) {
      if (result['success']) {
        Provider.of<Provider_Item>(context, listen: false)
            .customerOrderList
            .clear();
        Provider.of<Provider_Item>(context, listen: false)
            .clearCustomerOrder(customerCode: selectedCustomerCode);
        finishLoading();
        WavesWidgets()
            .snackBarSuccess(context: context, message: result['message']);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
    finishLoading();
  }

  Future createSalesInvoice({required BuildContext context}) async {
    Provider_Item itemdata = Provider.of<Provider_Item>(context, listen: false);
    setLoading();
    var result = await Api()
        .createSalesInvoice(context: context, customer: selectedCustomerCode);
    finishLoading();
    if (result != null) {
      if (result['success']) {
        WavesWidgets()
            .snackBarSuccess(context: context, message: result['message']);

        itemdata.clearCustomerOrder(customerCode: selectedCustomerCode);
        itemdata.customerOrderList.clear();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        WavesWidgets()
            .snackBarError(context: context, message: result['message']);
      }
    }
  }

  Future get_customer_OrderHistory({required BuildContext context}) async {
    setLoading();
    var result = await Api().getCustomerHistory(context: context);

    if (result != null) {
      if (result['success']) {
        List orders = result["history"];
        // if (orders.isNotEmpty) {
        customerOrderHistoryList.clear();
        for (var element in orders) {
          customerOrderHistoryList.add(CustomerOrderHistory(
              advance_paid: element["advance_paid"],
              balance: element[" balance"],
              distributor: element["distributor"].toString(),
              name: element["name"].toString(),
              orderDate: element["transaction_date"].toString(),
              amount: element["grand_total"].toDouble(),
              status: element["status"].toString()));
        }
        finishLoading();
        return customerOrderHistoryList;
        // }
        //  else {
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text(
        //           "History not found !",
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         actions: [
        //           TextButton(
        //             child: Text("OK"),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }
        // finishLoading();
      } else {
        finishLoading();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future getInvoices({required BuildContext context}) async {
    setLoading();
    var result = await Api().getInvoiceList(
      context: context,
    );
    finishLoading();
    if (result != null) {
      result = result['message'];
      if (result['success']) {
        List invoice = result["invoice_history"];
        // if (invoice.isNotEmpty) {
        invoiceHistoryList.clear();
        for (var element in invoice) {
          if (element['customer'] == selectedCustomerCode) {
            invoiceHistoryList.add(
              InvoiceHistory(
                customer: element["customer"].toString(),
                name: element["name"].toString(),
                posting_date: element["posting_date"].toString(),
                total: element["total"].toDouble(),
                status: element["status"].toString(),
              ),
            );
          }
          //else {
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         title: Text(
          //           "No Invoice Found !",
          //           style: TextStyle(fontSize: 18),
          //         ),
          //         actions: [
          //           TextButton(
          //             child: Text("OK"),
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //         ],
          //       );
          //     },
          //   );
          // }
        }

        return invoiceHistoryList;
        // } else {
        //   showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text(
        //           "History not found !",
        //           style: TextStyle(fontSize: 18),
        //         ),
        //         actions: [
        //           TextButton(
        //             child: Text("OK"),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future getCustomerCredits({required BuildContext context}) async {
    var result = await Api().creditLimit(context: context);
    log('${result}');
    if (result != null) {
      if (result['success']) {
        var credit = result['message'];
        creditLimit = credit['credit_limit'] ?? 0;
        outstandingAmount = credit['outstanding_amount'] ?? 0;
        creditBalance = credit['balance'] ?? 0;
        notifyListeners();
      }
    }
  }

  Future get_Customer_OrderDetails({required BuildContext context}) async {
    setLoading();
    salesOrderDetails.items = [];
    var result =
        await Api().getOrderDetails(context: context, orderId: salesOrderID!);
    if (result != null) {
      if (result['success']) {
        salesOrderDetails.items!.clear();
        result = result['order_details'];
        for (var i in result['items']) {
          salesOrderDetails.items!.add(CustomerOrder(
              item_name: i['item_name'],
              qty: i['qty'].toString(),
              amount: i['amount'].toString(),
              rate: i['rate'].toString()));
        }
        salesOrderDetails.status = result['status'];
        salesOrderDetails.sales_order_id = salesOrderID;
        salesOrderDetails.customer = result['customer'];
        salesOrderDetails.advance_paid = '${result['advance_paid'] ?? 0}';
        salesOrderDetails.balance =
            double.parse('${salesOrderDetails.sales_orderAmount ?? 0}') -
                double.parse('${salesOrderDetails.advance_paid ?? 0}');
        salesOrderDetails.sales_orderDate =
            WaveFunctions().reverseDate(date: result['transaction_date']);
        salesOrderDetails.delivery_date = result['delivery_date'] ?? '';
        // itemList.clear();
        finishLoading();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Screen_ViewSalesOrder()));
      }
    }
    // });
    else {
      finishLoading();
      WavesWidgets()
          .snackBarError(context: context, message: 'Smoething Went Wrong');
    }
  }

  downloadInvoice({required BuildContext context}) async {
    return await Api().downLoadInvoice(invoiceId: invoiceID!, context: context);
  }

  Future get_Customer_InvoiceDetails({required BuildContext context}) async {
    setLoading();
    invoiceDetails.items = [];
    var result =
        await Api().getInvoiceDetails(context: context, invoiceID: invoiceID!);
    if (result != null) {
      invoiceDetails.items!.clear();
      if (result['success']) {
        result = result['invoice_details'];
        for (var i in result['items']) {
          invoiceDetails.items!.add(CustomerOrder(
              item_name: i['item_name'],
              qty: i['qty'].toString(),
              amount: i['amount'].toString(),
              rate: i['rate'].toString()));
        }
        invoiceDetails.customer = selectedCustomerName;
        invoiceDetails.invoice_id = invoiceID!;
        invoiceDetails.outstanding_amount = '${result['outstanding_amount']}';
        invoiceDetails.invoiceDate = result['posting_date'].toString();
        invoiceDetails.invoiceAmount = result[''] ?? '0';
      }
      finishLoading();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Screen_ViewInvoice()));
    }
    finishLoading();
    // WavesWidgets()
    //     .snackBarError(context: context, message: 'Something went Wrong');
    // });
  }

  // Future paymentButton({
  //   required BuildContext context,
  //   required String id,
  //   required String source,
  //   required String amount,
  // }) async {
  //   setLoading();
  //   await Api().createPayment(
  //     context: context,
  //     sales_person: selectedExecutive!,
  //     customer: selectedDistributor!,
  //     mode: selectedPayment.value,
  //     sales_order: source == 'sales'
  //         ? [
  //             {"id": id, "amount": amountController.text}
  //           ]
  //         : [],
  //     sales_invoice: source == 'invoice'
  //         ? [
  //             {"id": id, "amount": amountController.text}
  //           ]
  //         : [],
  //     paid_amount: amountController.text,
  //     source: source,
  //   );
  //   finishLoading();
  // }

  // Future OutstandingAmount({
  //   required BuildContext context,
  // }) async {
  //   setLoading();
  //   final result = await Api().outstandingAmount(
  //     context: context,
  //     customer: selectedDistributor,
  //   );

  //   final message = result['message'];
  //   outstandingAmount = message['customer_outstanding'];
  //   finishLoading();
  // }

  // Future generateReportButton(String reportType) async {
  //   setLoading();
  //   await Api().LedgerRecievables(
  //     customer: selectedDistributor,
  //     fromDate: formatDate(fromdateController.text),
  //     toDate: formatDate(todateController.text),
  //     report: reportType,
  //   );
  //   String filters = jsonEncode({
  //     "customer": selectedDistributor,
  //     "from_date": formatDate(fromdateController.text),
  //     "to_date": formatDate(todateController.text),
  //     "company": "Wahni It Solutions",
  //   });
  //   finishLoading();
  //   reportUrl =
  //       'https://wahni-mobapp.frappe.cloud/api/method/api.report.generate_report_pdf?report=$reportType&filters=$filters';
  // }
}
