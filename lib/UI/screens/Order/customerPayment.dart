import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/Order/payment.dart';

class Screen_payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text("PAYMENT"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .03,
                        vertical: screenHeight * .01),
                    height: screenHeight * .12,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("Customer",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary)
                                  // TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     ),
                                  ),
                            ),
                            Expanded(
                                child: Text(
                              ':',
                              style: theme.textTheme.bodyMedium,
                            )),
                            Expanded(
                              flex: 8,
                              child: Consumer<Provider_Primary>(
                                  builder: (context, primary, child) {
                                return Text(primary.selectedCustomerName!
                                    .toUpperCase());
                              }),
                            )
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("Amount",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary)
                                  // TextStyle(
                                  //  ),
                                  ),
                            ),
                            Expanded(
                                child: Text(
                              ':',
                              style: theme.textTheme.bodyMedium,
                            )),
                            Expanded(
                              flex: 8,
                              child: Consumer<Provider_Primary>(
                                  builder: (context, primary, child) {
                                return Text(
                                    primary.outstandingAmount.toString());
                              }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * .05),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * .02),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Payment Date',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              ':',
                              style: theme.textTheme.bodySmall,
                            )),
                            Expanded(
                              flex: 8,
                              child: Consumer<Provider_Payment>(
                                  builder: (context, payment, child) {
                                return TextFormField(
                                  style: theme.textTheme.bodySmall,
                                  onTap: () async {
                                    var picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now()
                                            .add(const Duration(days: -365)),
                                        lastDate: DateTime.now());
                                    if (picked != null &&
                                        WaveFunctions().reverseDate(
                                                date: picked
                                                    .toString()
                                                    .substring(0, 10)) !=
                                            payment
                                                .paymentDateController.text) {
                                      payment.paymentDateController.text =
                                          WaveFunctions().reverseDate(
                                        date:
                                            picked.toString().substring(0, 10),
                                      );
                                    }
                                  },
                                  controller: payment.paymentDateController,
                                  decoration: InputDecoration(
                                    hintText: 'dd-mm-yy',
                                    suffixIcon: Icon(
                                      Icons.calendar_today,
                                      color: theme.colorScheme.primary,
                                      size: 18,
                                    ),
                                    // contentPadding: EdgeInsets.symmetric(
                                    //     vertical: 12, horizontal: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * .03),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Amount',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              ':',
                              style: theme.textTheme.bodyMedium,
                            )),
                            Expanded(
                              flex: 8,
                              child: Consumer<Provider_Payment>(
                                  builder: (context, payment, child) {
                                return TextFormField(
                                  style: theme.textTheme.bodySmall,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.currency_rupee,
                                        size: 18, color: Colors.blue),
                                    // contentPadding: EdgeInsets.symmetric(
                                    //     vertical: screenWidth * .01, horizontal: 16),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    errorText: payment.isAmountErrorNotifier
                                        ? 'Enter Amount'
                                        : null,
                                  ),
                                  controller: payment.paymentAmount,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      payment.isAmountErrorNotifier = true;
                                    } else {
                                      payment.isAmountErrorNotifier = false;
                                    }
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                        Container(
                          height: screenHeight * .3,
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * .03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Payment Mode',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    ':',
                                    style: theme.textTheme.bodyMedium,
                                  )),
                                  Expanded(
                                    flex: 8,
                                    child: Consumer<Provider_Payment>(
                                      builder: (context, payment, child) {
                                        return DropdownButton(
                                          hint: Text('Select Mode',
                                              style: theme.textTheme.bodySmall),
                                          isExpanded: true,
                                          underline: Container(),
                                          items: payment.paymodes
                                              .map(
                                                (mode) => DropdownMenuItem(
                                                    value: mode,
                                                    child: Text(mode)),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            payment.setPaymentMode(
                                                mode: value.toString());
                                            if (payment.selectedPayment !=
                                                'Cheque') {
                                              payment.isReferenceErrorNotifier =
                                                  false;
                                            }
                                          },
                                          value: payment.selectedPayment,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Consumer<Provider_Payment>(
                                  builder: (context, payment, child) {
                                return ((payment.selectedPayment != null &&
                                        payment.selectedPayment!
                                                .toLowerCase() ==
                                            'cheque')
                                    ? Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              'Cheque Date',
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                            ':',
                                            style: theme.textTheme.bodyMedium,
                                          )),
                                          Expanded(
                                            flex: 8,
                                            child: TextFormField(
                                              readOnly: true,
                                              style: theme.textTheme.bodySmall,
                                              controller:
                                                  payment.checkdateController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                  suffixIcon: const Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.blue,
                                                    size: 18,
                                                  ),
                                                  hintText: 'dd-mm-yy'),
                                              onTap: () async {
                                                var picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now().add(
                                                      const Duration(
                                                          days: -365)),
                                                  lastDate: DateTime.now().add(
                                                    Duration(days: 60),
                                                  ),
                                                );

                                                if (picked != null &&
                                                    WaveFunctions().reverseDate(
                                                            date: picked
                                                                .toString()
                                                                .substring(
                                                                    0, 10)) !=
                                                        payment
                                                            .checkdateController
                                                            .text) {
                                                  payment.setCheckdate(
                                                    date: WaveFunctions()
                                                        .reverseDate(
                                                            date: picked
                                                                .toString()
                                                                .substring(
                                                                    0, 10)),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Padding(padding: EdgeInsets.zero));
                              }),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Reference  : ',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    ':',
                                    style: theme.textTheme.bodyMedium,
                                  )),
                                  Expanded(
                                    flex: 8,
                                    child: Consumer<Provider_Payment>(
                                      builder: (context, payment, child) {
                                        return TextFormField(
                                          controller:
                                              payment.referenceController,
                                          decoration: InputDecoration(
                                              errorText: payment
                                                              .selectedPayment ==
                                                          'Cheque' &&
                                                      payment
                                                          .isReferenceErrorNotifier
                                                  ? 'Enter cheque number'
                                                  : null,
                                              // contentPadding: EdgeInsets.symmetric(
                                              //     vertical: 12, horizontal: 16),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18))),
                                          maxLines: 1,
                                          onChanged: (value) {
                                            if (payment.selectedPayment ==
                                                'Cheque') {
                                              payment.isReferenceErrorNotifier =
                                                  value.isEmpty;
                                            } else {
                                              payment.isReferenceErrorNotifier =
                                                  false;
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * .02),
                        // ButtonBar(alignment: MainAxisAlignment.center, children: [
                        Consumer<Provider_Payment>(
                            builder: (context, payment, child) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.blue[50],
                                minimumSize: Size(200, 40),
                              ),
                              onPressed: () async {
                                await payment.paymentButtonPressed(
                                    context: context);
                              },
                              child: Text('PAYMENT'));
                        }),
                        // ])
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: Consumer<Provider_Payment>(
                    builder: (context, payment, child) {
                  return payment.isLoading
                      ? WavesWidgets().loadingWidget(context: context)
                      : Padding(padding: EdgeInsets.zero);
                }))
          ],
        ));
  }
}
