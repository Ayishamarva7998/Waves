import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/constants/colors.dart';

class Screen_ViewInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    var data =
        Provider.of<Provider_Primary>(context, listen: false).invoiceDetails;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(data.customer.toString().toUpperCase()),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          //  physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(height: screenHeight * .02),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenwidth * .03),
              height: screenHeight * .17,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: Padding(
                padding: EdgeInsets.only(left: screenwidth * .025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Invoice No',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            flex: 7,
                            child: Text(data.invoice_id.toString(),
                                style: theme.textTheme.bodySmall))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Invoice Date',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            flex: 7,
                            child: Text(data.invoiceDate.toString(),
                                style: theme.textTheme.bodySmall))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Customer',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Consumer<Provider_Primary>(
                            builder: (context, primary, child) {
                          return Expanded(
                              flex: 7,
                              child: Text(
                                  primary.selectedCustomerName.toString(),
                                  style: theme.textTheme.bodySmall));
                        })
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Amount',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            flex: 7,
                            child: Text(data.invoiceAmount.toString(),
                                style: theme.textTheme.bodySmall))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * .025),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2),
                      height: screenHeight * .05,
                      decoration: BoxDecoration(color: WaveColors.liteBlue),
                      child: Text(
                        "SL",
                        style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    height: screenHeight * .05,
                    decoration: const BoxDecoration(color: WaveColors.liteBlue),
                    child: Text(
                      "Item",
                      style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: screenHeight * .05,
                      decoration:
                          const BoxDecoration(color: WaveColors.liteBlue),
                      child: Text(
                        "Qty",
                        style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      height: screenHeight * .05,
                      decoration:
                          const BoxDecoration(color: WaveColors.liteBlue),
                      child: Text(
                        "Rate",
                        style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(2),
                    height: screenHeight * .05,
                    decoration: const BoxDecoration(color: WaveColors.liteBlue),
                    child: Text(
                      "Amount",
                      style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            Container(
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.items!.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: ((context, index) {
                  var item = data.items![index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.center,
                              // height: screenHeight * .05,
                              padding: const EdgeInsets.all(2),
                              child: Text('${index + 1}')),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(right: 4),
                            child: Center(child: Text(item.item_name ?? '')),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(item.qty!),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 11),
                            child: Text(item.rate!),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 9),
                            child: Text(item.amount!),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          WavesWidgets().toastMessage(
              context: context,
              message: 'Searching for devices',
              milliseconds: 5000,
              icon: CircularProgressIndicator());
          Uint8List pdfdata =
              await Provider.of<Provider_Primary>(context, listen: false)
                  .downloadInvoice(context: context);
          ScaffoldMessenger.of(context).clearSnackBars();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: StreamBuilder(
                  stream: FlutterBluetoothPrinter.discovery,
                  builder: (context, snapshot) {
                    log('${snapshot.data}');
                    bool device = false;
                    dynamic list;

                    if (snapshot.data != null) {
                      list = snapshot.data;
                      try {
                        if (list.devices != null) {
                          device = true;
                        }
                      } on NoSuchMethodError catch (e) {
                        device = false;
                      }
                    } else {
                      device = false;
                      // list = [];
                    }
                    return Container(
                      // color: Colors.red,
                      height: device ? screenHeight * .4 : 500,
                      child: device
                          ? Container(
                              height: screenHeight * .3,
                              width: screenwidth * .3,
                              // color: Colors.green,

                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(color: Colors.amber),
                                  itemCount: list.devices.length,
                                  itemBuilder: (cntxt, index) {
                                    var de = list.devices.elementAt(index);
                                    // log('device[$index] : ${de.name}');
                                    return ListTile(
                                      title: Text(
                                        '${de.name}',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(color: Colors.green),
                                      ),
                                      subtitle: Text(
                                        '${de.address}',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(color: Colors.green),
                                      ),
                                      onTap: () async {
                                        try {
                                          await FlutterBluetoothPrinter
                                              .printBytes(
                                                  address: de.address,
                                                  data: (
                                                      pdfdata),
                                                  keepConnected:
                                                      true // some image
                                                  );
                                        } catch (e) {
                                          WavesWidgets().snackBarError(
                                              context: context, message: '$e');
                                        }
                                        Navigator.of(cntxt).pop();
                                      },
                                    );
                                    // ListTile(
                                    //     title: Text(device.name ?? 'No Name'),
                                    //     subtitle: Text(device.address),
                                    //     onTap: () {
                                    //       // do anything
                                    //
                                    //     });
                                  }),
                            )
                          : Center(child: Text('No Device found')),
                    );
                  }),
            ),
          );
          // buttons: [
          // DialogButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: Text(
          //     "LOGIN",
          //     style: TextStyle(color: Colors.white, fontSize: 20),
          //   ),
          // )
          // ],);
          // Alert(
          //   context: context,
          //   title: "Select Device",
          //   content: StreamBuilder(
          //       stream: FlutterBluetoothPrinter.discovery,
          //       builder: (context, snapshot) {
          //         log('${snapshot.data}');
          //         bool device = false;
          //         dynamic list;

          //         if (snapshot.data != null) {
          //           list = snapshot.data;
          //           device = true;
          //         } else {
          //           device = false;
          //           // list = [];
          //         }
          //         return Container(
          //           height: device
          //               ? (list.devices.length * (screenHeight * .1))
          //               : 500,
          //           child: device
          //               ? ListView.separated(
          //                   separatorBuilder: (context, index) => Divider(
          //                         color: Colors.amber,
          //                       ),
          //                   itemCount: list.devices.length,
          //                   itemBuilder: (context, index) {
          //                     final device = list.devices.elementAt(index);
          //                     print('device[$index] : ${device}');
          //                     return Text(device.name ?? 'No Name');
          //                     // ListTile(
          //                     //     title: Text(device.name ?? 'No Name'),
          //                     //     subtitle: Text(device.address),
          //                     //     onTap: () {
          //                     //       // do anything
          //                     //       FlutterBluetoothPrinter.printBytes(
          //                     //           address: device.address,
          //                     //           data: pdfdata,
          //                     //           keepConnected: true // some image
          //                     //           );
          //                     //     });
          //                   })
          //               : Center(child: Text('No Device found')),
          //         );
          //       }),
          //   // buttons: [
          //   // DialogButton(
          //   //   onPressed: () => Navigator.pop(context),
          //   //   child: Text(
          //   //     "LOGIN",
          //   //     style: TextStyle(color: Colors.white, fontSize: 20),
          //   //   ),
          //   // )
          //   // ]
          // ).show();

          // http.Response response = await http.get(
          //     Uri.parse('http://www.africau.edu/images/default/sample.pdf'));
          // var pdfData = response.bodyBytes;
          // await Printing.layoutPdf(
          //     onLayout: (format) async => pdfData, format: PdfPageFormat.a5); //
        },
        heroTag: 'download invoice',
        child: Icon(Icons.print),
      ),
    );
  }
}
