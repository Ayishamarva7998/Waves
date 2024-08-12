import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/screens/Printing/printing.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Invoice/invoiceprovider.dart';
import 'package:waves/Utilities/providers/Printer/printer_provider.dart';


import '../../../Utilities/providers/Order/Primarysales.dart';

class Screen_SalesPersonInvoices extends StatefulWidget {
  const Screen_SalesPersonInvoices({super.key});

  @override
  State<Screen_SalesPersonInvoices> createState() =>
      _Screen_SalesPersonInvoicesState();
}

class _Screen_SalesPersonInvoicesState
    extends State<Screen_SalesPersonInvoices> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          "INVOICES",
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenwidth * .02, vertical: screenHeight * .02),
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          flex: 5,
                          child: Consumer<Provider_Invoice>(
                              builder: (context, invoice, child) {
                            return TextFormField(
                              style: theme.textTheme.bodySmall,
                              controller: invoice.fromdate,
                              readOnly: true,
                              onTap: () async {
                                var picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 365)),
                                    lastDate: DateTime.now());
                                if (picked != null &&
                                    WaveFunctions().reverseDate(
                                            date: picked
                                                .toString()
                                                .substring(0, 10)) !=
                                        invoice.fromdate.text) {
                                  invoice.setfromdate(
                                      date: picked.toString().substring(0, 10));
                                }
                              },
                              decoration: InputDecoration(
                                  label: Text('From'),
                                  labelStyle: theme.textTheme.bodySmall,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            );
                          })),
                      Expanded(child: SizedBox()),
                      Expanded(
                          flex: 5,
                          child: Consumer<Provider_Invoice>(
                              builder: (context, invoice, child) {
                            return TextFormField(
                              style: theme.textTheme.bodySmall,
                              controller: invoice.todate,
                              readOnly: true,
                              onTap: () async {
                                var picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 365)),
                                    lastDate: DateTime.now());
                                if (picked != null &&
                                    WaveFunctions().reverseDate(
                                            date: picked
                                                .toString()
                                                .substring(0, 10)) !=
                                        invoice.todate.text) {
                                  invoice.settodate(
                                      date: picked.toString().substring(0, 10));
                                }
                              },
                              decoration: InputDecoration(
                                  label: Text('To'),
                                  labelStyle: theme.textTheme.bodySmall,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            );
                          })),
                      Expanded(child: SizedBox()),
                      Expanded(
                          flex: 5,
                          child: Consumer<BluetoothProvider>(
                              builder: (context, invoice, child) {
                            return ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrinterWidget(),));
                                },
                                child: Text('Get'));
                          })),
                    ],
                  )),
                  Expanded(child: SizedBox()),
                  Expanded(
                      flex: 15,
                      child: Container(
                        child: Consumer<Provider_Invoice>(
                            builder: (context, invoice, child) {
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                var data =
                                    invoice.salespersonInvoicelist[index];
                                return GestureDetector(
                                  onTap: () async {
                                    Provider_Primary primary =
                                        Provider.of<Provider_Primary>(context,
                                            listen: false);
                                    primary.invoiceID = data.name;
                                    primary.selectedCustomerName =
                                        data.customer;
                                    await primary.get_Customer_InvoiceDetails(
                                      context: context,
                                    );
                                  },
                                  child: Container(
                                    height: screenHeight * .2,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            padding: const EdgeInsets.all(10),
                                            child: Center(
                                                child: Image.asset(
                                                    "assets/images/bill.png")),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        'customer',
                                                        style: theme.textTheme
                                                            .bodySmall,
                                                      )),
                                                  Expanded(
                                                      child: Text(
                                                    ':',
                                                    style: theme
                                                        .textTheme.bodySmall,
                                                  )),
                                                  Expanded(
                                                      flex: 8,
                                                      child: Text(
                                                        '${data.customer}',
                                                        style: theme.textTheme
                                                            .bodySmall,
                                                      ))
                                                ],
                                              )),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        'Invoice',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ':',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Text(
                                                        ' ${data.name}',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        'Date',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ':',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Text(
                                                        ' ${WaveFunctions().reverseDate(date: data.posting_date.toString())}',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        'Amount',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        ':',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Text(
                                                        ' ${data.total}',
                                                        style: theme.textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 13,
                                                                color: theme
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Text(
                                              //   '          :  ',
                                              //   style: theme.textTheme.bodySmall!.copyWith(
                                              //       fontWeight: FontWeight.w500,
                                              //       fontSize: 13,
                                              //       color: theme.textTheme.bodySmall!.color),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        // showPaymentButton
                                        //     ?
                                        // Expanded(
                                        //         flex: 2,
                                        //         child: GestureDetector(
                                        //             onTap: () {
                                        //               // Navigator.of(context).push(
                                        //               //   MaterialPageRoute(
                                        //               //     builder: (context) =>
                                        //               //         Screen_Payment_Invoice_sales(
                                        //               //       amount: datatotal.toString(),
                                        //               //       id: invoice.name,
                                        //               //       date: reverseDate(
                                        //               //           date: invoice.posting_date.toString()),
                                        //               //       source: 'invoice',
                                        //               //     ),
                                        //               //   ),
                                        //               // );
                                        //             },
                                        //             child: Text(
                                        //               "Payment",
                                        //               textAlign: TextAlign.center,
                                        //               style: theme.textTheme.bodySmall!
                                        //                   .copyWith(
                                        //                       fontWeight: FontWeight.w500,
                                        //                       fontSize: 13,
                                        //                       color: theme.primaryColor),
                                        //             )),
                                        //       )
                                        //     :
                                        Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              child: Text('${data.status}',
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          color: Colors.green)),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: invoice.salespersonInvoicelist.length);
                        }),
                      ))
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Consumer<Provider_Primary>(
              builder: (context, primary, child) {
                return primary.isLoading
                    ? WavesWidgets().loadingWidget(context: context)
                    : Padding(padding: EdgeInsets.zero);
              },
            ),
          )
        ],
      ),
    );
  }
}
