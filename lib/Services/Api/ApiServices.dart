import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_safe_plus/open_file_safe_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/Attendance/attendanceModel.dart';
import 'package:waves/Models/DataBase/customerorderlist.dart';
import 'package:waves/Services/Location/locationServices.dart';
import 'package:waves/Services/Preferences/preferences.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Invoice/invoiceprovider.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Api {
  // final String cloud = 'https://classic.zedcoapps.com/';
  final String cloud = 'http://109.123.230.242:8000/';
  final String path = 'api/method/classic.api.v1.';
  Dio dio = Dio();

  late Response response;
  getToken() async {
    String? token;
    await PrefernceData().getToken().then((value) => token = value);
    _headers.addAll({'Authorization': 'Basic $token'});
  }

  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive'
  };
  Future authenticate(
      {required BuildContext context,
      required String username,
      required String password}) async {
    String endpoint = 'auth.authenticate';
    try {
      _headers = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive'
      };
      response = await dio
          .post('$cloud$path$endpoint',
              data: {"username": username, "password": password},
              options: Options(headers: _headers))
          .timeout(
            const Duration(seconds: 8),
          );
      return response.data['message'];
    } on DioException catch (error) {
      await exeptionFunction(error: error, context: context, enpoint: endpoint);
    } on TimeoutException {
      WavesWidgets().snackBarError(
          context: context, message: 'Connection error\nTry Again Later');
    } catch (e) {
      log('$e');
    }
  }

  Future? postApicall({
    required BuildContext context,
    required String endpoint,
    required Map body,
  }) async {
    await getToken();
    try {
      response = await dio
          .post('$cloud$path$endpoint',
              options: Options(headers: _headers), data: body)
          .timeout(Duration(seconds: 10));
      _headers.remove('Authorization');
      return response.data;
    } on DioException catch (error) {
      await exeptionFunction(error: error, context: context, enpoint: endpoint);
    } on TimeoutException {
      WavesWidgets().snackBarError(
          context: context, message: 'Connection error\nTry Again Later');
    } catch (error) {
      log('$error');
    }
  }

  Future? getApicall(
      {required BuildContext? context,
      required String endpoint,
      body = const {}}) async {
    await getToken();
    try {
      response = await dio
          .get('$cloud$path$endpoint',
              options: Options(headers: _headers), data: body)
          .timeout(Duration(seconds: 10));
      return response.data;
    } on DioException catch (error) {
      await exeptionFunction(error: error, context: context, enpoint: endpoint);
    } catch (error) {
      log('$error');
    }
  }

  Future getAttendanceStatus({required BuildContext context}) async {
    var result = await getApicall(
      context: context,
      endpoint: 'general.get_attendance_status',
    );
    if (result != null) {
      var attendenceStatus = result['message'];
      return attendenceStatus;
    }
  }

  Future markAttendence(BuildContext context,
      {required CheckInData checkOut}) async {
    var result = await postApicall(
        context: context,
        endpoint: 'general.mark_attendance',
        body: {
          'longitude': '${checkOut.longitude}',
          'latitude': '${checkOut.latitude}',
          'street': '${checkOut.route}',
          'postal_code': '${checkOut.postalCode}',
          'district': '${checkOut.district}',
        });
    if (result != null) {
      return result['message'];
    }
  }

  Future getRoutes({required BuildContext context}) async {
    var result =
        await getApicall(context: context, endpoint: 'general.route_list');
    if (result != null) {
      return result['message'];
    }
  }

  Future getCustomers(
      {required BuildContext context, required String route}) async {
    var result = await getApicall(
        context: context,
        endpoint: 'general.customer_list',
        body: {'route': '${route}'});
    //   log("${result}");
    if (result != null) {
      return result['message'];
    }
  }

  getItemList({required BuildContext context}) async {
    var result = await postApicall(
        context: context, endpoint: 'general.item_list', body: {});
    if (result != null) {
      return result['message'];
    }
    //general.item_list
  }

  placeSalesOrder({required BuildContext context}) async {
    Provider_Primary primary =
        Provider.of<Provider_Primary>(context, listen: false);
    Provider_Item itemdata = Provider.of<Provider_Item>(context, listen: false);
    LocationServices locationservice =
        Provider.of<LocationServices>(context, listen: false);
    Provider_SalesPerson person =
        Provider.of<Provider_SalesPerson>(context, listen: false);
    List<Map> orderlist = [];
    for (var item in itemdata.customerOrderList) {
      orderlist.add({
        "item_code": "${item.itemCode}",
        "qty": "${item.itemQty}",
        "rate": "${item.itemRate}"
      });
    }
    if (orderlist.isNotEmpty) {
      if (await ConnectivityWrapper.instance.isConnected) {
        var response = await postApicall(
            context: context,
            endpoint: 'orders.sales_order',
            body: {
              'latitude': locationservice.latitude,
              'longitude': locationservice.longitude,
              'distributor': '${primary.selectedCustomerCode}',
              'sales_person': '${person.name}',
              'items': orderlist
            });
        if (response != null) {
          return response['message'];
        }
      }
    } else {
      //   // ScaffoldMessenger.of(context).removeCurrentSnackBar();
      // ScaffoldMessenger.of(context)
      //   ..showSnackBar(Wa().snackBarError(
      //       context: context, msg: 'Not Connected to NetWork'));

      await Provider.of<Provider_Item>(context, listen: false).saveOflineOrders(
          customerCode: primary.selectedCustomerCode!,
          lattitude: locationservice.latitude,
          longitude: locationservice.longitude);
      // await Workmanager().registerPeriodicTask(
      //   "1",
      //   'ofline_order_sync',
      //   initialDelay: Duration(minutes: 1),
      //   frequency: Duration(minutes: 15),
      // );
      await Provider.of<Provider_Item>(context, listen: false)
          .getoflineOrderCount();
      WavesWidgets().snackBarSuccess(
          context: context, message: 'Your Order Will Sync to ERP Latter');
      await Provider.of<Provider_Item>(context, listen: false)
          .getoflineOrderCount();
      await Provider.of<Provider_Item>(context, listen: false).clearItemQty();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Future syncOrder(
      {required latitude,
      required longitude,
      required customer,
      required List itemlist}) async {
    String endpoint = 'orders.sales_invoice';
    try {
      final _storage = const FlutterSecureStorage();
      IOSOptions _getIOSOptions() =>
          const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

      AndroidOptions _getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      //  Future getToken() async {
      String securekey = await _storage.read(
            key: 'SecureKey',
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions(),
          ) ??
          '';
      //   return securekey;
      // }
      log('$securekey');
      _headers = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Authorization': 'Basic $securekey'
      };
      log('$cloud$path$endpoint');
      response = await Dio().post(
        '$cloud$path$endpoint',
        options: Options(headers: _headers),
        data: {
          'latitudes': latitude,
          'longitude': longitude,
          'customer': customer,
          'items': itemlist
        },
      ).timeout(const Duration(seconds: 10));
      ;
      if (response != null) {
        var result = response!.data['message'];
        if (result['success']) {
          var orderlist = await Hive.openBox<CustomerOrderList>('orderList');
          List itemtodelete = [];
          int i = 0;
          for (var n in orderlist.values) {
            if (n.customercode == customer) {
              itemtodelete.add(i);
              orderlist.putAt(
                  i,
                  CustomerOrderList(
                      amount: n.amount,
                      customerName: n.customerName,
                      customercode: n.customercode,
                      isSubmitted: 3,
                      itemCode: n.itemCode,
                      itemName: n.itemCode,
                      itemQty: n.itemQty,
                      itemRate: n.itemRate,
                      latitude: n.latitude,
                      salesPerson: n.salesPerson,
                      longitude: n.longitude.toString()));
            }
            i++;
          }
          orderlist = await Hive.openBox<CustomerOrderList>('orderList');
          for (int n = itemlist.length - 1; n >= 0; n--) {
            await orderlist.deleteAt(itemtodelete[n]);
          }
          bool iselementfound = false;
          orderlist.values.forEach((element) {
            if (element.isSubmitted == 1) {
              iselementfound = true;
            }
          });
          if (!iselementfound) {
            // await Provider_Item().getoflineOrderCount();
            // await Workmanager().cancelAll();
            Provider_Item().oflineordercount = 0;
          }
        }
      }

      return true;
    } on DioException catch (error) {
      log('$error');
    } catch (e) {
      log('$e');
    }
    // }
  }

  Future createSalesInvoice({
    required BuildContext context,
    required customer,
    int isPos = 0,
    saleOrder = '',
    dueDate = '',
    List payment = const [],
  }) async {
    LocationServices locationservice =
        Provider.of<LocationServices>(context, listen: false);
    List<Map> items = [];
    Provider_Primary primary =
        Provider.of<Provider_Primary>(context, listen: false);
    Provider_SalesPerson person =
        Provider.of<Provider_SalesPerson>(context, listen: false);
    Provider_Item itemdata = Provider.of<Provider_Item>(context, listen: false);
    for (var item in itemdata.customerOrderList) {
      items.add({
        "item_code": "${item.itemCode}",
        "qty": "${item.itemQty}",
        "rate": "${item.itemRate}"
      });
    }
    Map body = {
      'distributor': '${primary.selectedCustomerCode}',
      'lattitude': '${locationservice.latitude}',
      'longitude': '${locationservice.longitude}',
      // 'sales_person': '${person.name}',
      'items': items
    };
    if (await ConnectivityWrapper.instance.isConnected) {
      var response = await postApicall(
          context: context, endpoint: 'orders.sales_invoice', body: body);
      if (response != null) {
        return response['message'];
      }
    } else {
      //   // ScaffoldMessenger.of(context).removeCurrentSnackBar();
      // ScaffoldMessenger.of(context)
      //   ..showSnackBar(Wa().snackBarError(
      //       context: context, msg: 'Not Connected to NetWork'));

      await Provider.of<Provider_Item>(context, listen: false).saveOflineOrders(
          customerCode: primary.selectedCustomerCode!,
          lattitude: locationservice.latitude,
          longitude: locationservice.longitude);
      // await Workmanager().registerPeriodicTask(
      //   "1",
      //   'ofline_order_sync',
      //   initialDelay: Duration(minutes: 1),
      //   frequency: Duration(minutes: 15),
      // );
      await Provider.of<Provider_Item>(context, listen: false)
          .getoflineOrderCount();
      WavesWidgets().snackBarSuccess(
          context: context, message: 'Your Order Will Sync to ERP Latter');
      await Provider.of<Provider_Item>(context, listen: false)
          .getoflineOrderCount();
      await Provider.of<Provider_Item>(context, listen: false).clearItemQty();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Future getCustomerHistory({required BuildContext context}) async {
    String distributor = Provider.of<Provider_Primary>(context, listen: false)
        .selectedCustomerCode
        .toString();

    var response = await postApicall(
        context: context,
        endpoint: 'orders.sales_order_history',
        body: {'distributor': '$distributor'});
    if (response != null) {
      return response['message'];
    }
  }

  Future getInvoiceList({required context}) async {
    var response = await postApicall(
        context: context, endpoint: "orders.sales_invoice_history", body: {});
    if (response != null) {
      var InvoiceList = response;
      return InvoiceList;
    }
  }

  Future getPaymentModes({required BuildContext context}) async {
    var response = await getApicall(
        context: context, endpoint: 'general.get_mode_of_payment', body: {});
    var result = response;
    if (result != null) {
      return result['message'];
    }
  }

  Future getInvoiceDetails(
      {required context, required String invoiceID}) async {
    // String invoiceId =
    //     Provider.of<Primary>(context, listen: false).invoiceID.toString();
    var response = await postApicall(
        context: context,
        endpoint: 'orders.get_invoice_details',
        body: {"invoice_id": invoiceID});
    if (response != null) {
      return response['message'];
    }
  }

  Future getOrderDetails({required context, required String orderId}) async {
    // String invoiceId =
    //     Provider.of<Primary>(context, listen: false).invoiceID.toString();
    var response = await postApicall(
        context: context,
        endpoint: 'orders.get_order_details',
        body: {"order_id": orderId});
    if (response != null) {
      return response['message'];
    }
  }

  Future creditLimit({required BuildContext context}) async {
    Provider_Primary primary =
        Provider.of<Provider_Primary>(context, listen: false);
    var response = await postApicall(
        context: context,
        endpoint: 'general.credit_limit_and_period',
        body: {"customer": primary.selectedCustomerCode});
    if (response != null) {
      var result = response['message'];
      return result;
      // return result['invoice_details'];
    }
  }

  Future addnewCustomer(
    context, {
    customer_name,
    pincode,
    address,
    city,
    state,
    country,
    place,
    latitude,
    longitude,
    gstin,
    company_type,
    customer_route,
    customer_group,
    territory,
    String? contactPerson,
    gst_category,
    String? upiId,
    email_id,
    mobile_no,
  }) async {
    String? base64Image;
    String? fileType;

    var response = await postApicall(
      context: context,
      endpoint: 'generic.create_customer',
      body: {
        'file_type': fileType,
        'gstin': '$gstin',
        'customer_name': '$customer_name',
        'custom_contact_person': contactPerson,
        "custom_upi_ids": [
          {"upi_id": "${upiId}", "is_default": upiId == '' ? 0 : 1},
        ],
        'customer_group': '$customer_group',
        'route': '$customer_route',
        'territory': '$territory',
        'gst_category': '$gst_category',
        'email_id': '$email_id',
        'mobile_no': '$mobile_no',
        'image': base64Image,
        'latitude': '$latitude',
        'longitude': '$longitude',
        'address_line1': '$address',
        'city': '$city',
        'pincode': '$pincode',
        'state': '$state',
        'country': '$country',
        'is_default': 1
      },
    );

    var result = response;
    log("ADD CUSTOMER ${result}");
    if (result['message'] != null) {
      return result['message'];
    }
  }

  Future createPayment(
      {required context,
      required mode,
      required customer,
      required paid_amount,
      required source,
      List sales_invoice = const [],
      List sales_order = const [],
      required String sales_person}) async {
    var response = await postApicall(
        context: context,
        endpoint: 'general.payment_entry',
        body: {
          "mode": "$mode",
          "customer": "$customer",
          "paid_amount": "$paid_amount",
        });

    return response['message'];
  }

  Future getLeaveList(context, {fromdate, todate}) async {
    var response = await postApicall(
      context: context,
      endpoint: 'generic.list_leave_application',
      body: {'from_date': '$fromdate', 'to_date': '$todate'},
    );
    if (response != null) {
      return response['message'];
    }
  }

  Future getLeaveType({context}) async {
    var response = await postApicall(
        context: context, endpoint: 'generic.get_leave_type', body: {});
    if (response != null) {
      return response['message'];
    }
  }

  Future leaveRequest(
      {context, employee, leaveType, fromDate, todate, reason}) async {
    var response = await postApicall(
        context: context,
        endpoint: 'generic.create_leave_application',
        body: {
          "employee": "$employee",
          "leave_type": "$leaveType",
          "from_date": "$fromDate",
          "to_date": "$todate",
          "reason": "$reason"
        });
    if (response != null) {
      return response['message'];
    }
  }

  Future getSalesPersonInvoices({required BuildContext context}) async {
    Provider_Invoice invoice =
        Provider.of<Provider_Invoice>(context, listen: false);
    var response = await postApicall(
        context: context,
        endpoint: 'orders.sales_invoice_date_history',
        body: {
          // "employee": "$employee",
          // "leave_type": "$leaveType",
          "from_date":
              "${WaveFunctions().reverseDate(date: invoice.fromdate.text)}",
          "to_date":
              "${WaveFunctions().reverseDate(date: invoice.todate.text)}",
          // "reason": "$reason"
        });
    if (response != null) {
      return response['message'];
    }
  }

  Future downLoadInvoice(
      {required String invoiceId, required BuildContext context}) async {
    String? url;
    // invoiceId = 'ACC-SINV-2024-00010';
    await getToken();
    var response = await getApicall(
        context: context,
        endpoint: 'orders.get_invoice_pdf_link',
        body: {'invoice_id': '${invoiceId}'});
    // // log('${response}');
    if (response != null) {
      response = response['message'];
      if (response['success']) {
        url = response['url'];
        await getToken();
        log('${url}');
        http.Response responce = await http.get(
          headers: _headers,
          Uri.parse('$url'),
        );
        var pdfData = responce.bodyBytes;
        return pdfData;

        // await Printing.layoutPdf(
        //     onLayout: (format) async => pdfData, format: PdfPageFormat.roll57);
      }
      //   log('${url}');
      // await Provider.of<Provider_Primary>(context, listen: false)
      //     .downloadInvoice(context: context);

      // downLoadFile(
      //     // body: {'invoice_id': '${invoiceId}'},
      //     endpoint: url,
      //     fileName: 'invoice',
      //     context: context);
    }
  }

  downLoadFile(
      {required endpoint,
      required fileName,
      // Map<String, dynamic> body = const {},
      required BuildContext context}) async {
    try {
      // String resulturl = '${cloud}${path}${endpoint}';

      Directory? dir;
      try {
        dir = (Platform.isAndroid
            ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory());
      } on FileSystemException {
        dir = (Platform.isAndroid
            ? await getTemporaryDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory());
      } catch (e) {}

      String newPath = "";
      String filepath = "";
      List<String> paths = dir!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath = newPath + "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Download";
      dir = Directory(newPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      if (await dir.exists()) {
        filepath = dir.path;
        //  save the file.
        await getToken();
        Dio dio = Dio();
        // log('$resulturl');
        filepath = filepath + '/$fileName.pdf';

        await dio.download(
          options: Options(headers: _headers),
          endpoint,
          filepath, //data: body,
          onReceiveProgress: (rcv, total) async {
            if (rcv >= total) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              WavesWidgets().snackBarSuccess(
                  message: 'Download Completed', context: context);
              await OpenFileSafePlus.open(filepath);
            }
          },
          // ignore: body_might_complete_normally_catch_error
        ).catchError((e) {
          log('${e}');
          // ScaffoldMessenger.of(context).showSnackBar(
          WavesWidgets()
              .snackBarError(message: 'No Files Found', context: context);
        });
        // log('RESULT:   ${result}');
      }
    } on SocketException catch (e) {
      log('$e');
    } on DioException catch (e) {
      log('${e.response}');
      exeptionFunction(error: e, enpoint: endpoint, context: context);
    } catch (e) {
      StackTrace.fromString('$e');
      log('$e');
    }
  }

  Future exeptionFunction(
      {required error, required context, required enpoint}) async {
    log('$error');
    try {
      if (error.type == DioExceptionType.connectionTimeout) {
        WavesWidgets().snackBarError(
            context: context, message: 'Connection error\nTry Again Later');
      } else if (error.type == DioExceptionType.receiveTimeout) {
        // ScaffoldMessenger.of(context).showSnackBar(
        // Wa().snackBarError(
        // context: context, msg: 'Connection error\nTry Again Later'));
      } else if (error.type == DioExceptionType.badResponse) {
        if (error.response!.statusCode == 403 ||
            error.response!.statusCode == 401) {
          _headers.clear();
          // await LocalStorage().logout(context);
        } else if (error.response!.statusCode == 404) {
          // ScaffoldMessenger.of(context).showSnackBar(Wa().snackBarError(
          // context: context, msg: 'Connection error\nTry Again Later'));
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(Wa().snackBarError(
          // context: context, msg: 'Connection error\nTry Again Later'));
        }
      } else {
        if (error.error.message == 'Connection failed') {
          // ScaffoldMessenger.of(context).showSnackBar(Wa().snackBarError(
          //     context: context, msg: 'Connection error\nTry Again Later'));
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(Wa().snackBarError(
          //     context: context, msg: 'Connection error\nTry Again Later'));
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
