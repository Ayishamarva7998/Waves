import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Location/locationServices.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/UI/widgets/Order/orderDetails.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Screen_AddedItems extends StatelessWidget {
  late Provider_Item itemdata;
  late Provider_SalesPerson salesPerson;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    itemdata = Provider.of<Provider_Item>(context, listen: false);
    salesPerson = Provider.of<Provider_SalesPerson>(context, listen: false);
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      //  AppColors().backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Provider.of<LocationServices>(context, listen: false)
                .stopWatchingUserLocation();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("ORDER DETAILS", style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .02,
                        vertical: screenHeight * .01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Customer Name',
                                    style: theme.textTheme.bodySmall,
                                  )),
                              Expanded(
                                  child: Text(':',
                                      style: theme.textTheme.bodySmall)),
                              Expanded(
                                flex: 8,
                                child: Consumer<Provider_Primary>(
                                  builder: (context, primary, child) => Text(
                                    '${primary.selectedCustomerName}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(flex: 5, child: SizedBox()),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Date',
                                    style: theme.textTheme.bodySmall,
                                  )),
                              Expanded(
                                  child: Text(':',
                                      style: theme.textTheme.bodySmall)),
                              Expanded(
                                  flex: 8,
                                  child: Text(
                                    '${WaveFunctions().reverseDate(date: DateTime.now().toUtc().toString().substring(0, 10))}',
                                    style: theme.textTheme.bodySmall,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // salesPerson.orderType == 1
              //     ?

              // : Padding(padding: EdgeInsets.zero),
              Expanded(
                child: Container(
                  color: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .02,
                      vertical: screenHeight * .01),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Items',
                          style: theme.textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                          // textAlign: TextAlign.justify,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                'Amount',
                                style: theme.textTheme.bodySmall,
                                // textAlign: TextAlign.justify,
                              ),
                            ),
                            Expanded(
                              child: Consumer<Provider_Item>(
                                  builder: (context, item, chuld) {
                                return Text(
                                  '${itemdata.totalAmount}',
                                  style: theme.textTheme.bodySmall,
                                  // textAlign: TextAlign.justify,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: ListView(
                  children: [
                    NewOrderList(),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Provider.of<Provider_Primary>(context,
                                listen: false)
                            .createSalesInvoice(context: context);
                      },
                      child: Text(
                        'Create Invoice',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        Consumer<Provider_Primary>(builder: (context, primary, child) {
          return Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: primary.isLoading
                  ? WavesWidgets().loadingWidget(context: context)
                  : Padding(padding: EdgeInsets.zero));
        })

        // Consumer<Provider_Primary>(
        //   builder: (context, primary, child) => primary.isLoading
        //       ? App_Widgets().loadingWidget()
        //       : Container(
        //           // color: Colors.green,
        //           ),
        // )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
/*    Expanded(
                child: Container(
                  width: double.infinity,
                  height: screenHeight * .10,
                  color: theme.colorScheme.primary.withOpacity(.2),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: screenWidth * .02),
                          child: PopupMenuButton(
                            position: PopupMenuPosition.under,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * .01),
                              height: screenHeight * .05,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        'Create',
                                        textAlign: TextAlign.start,
                                        style: theme.textTheme.titleSmall,
                                      ),
                                    ),
                                    const Expanded(
                                        child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ))
                                  ]),
                            ),
                            itemBuilder: (context) => [
                              // PopupMenuItem(
                              //   child: Text('Sales Order'),
                              //   onTap: () {
                              //     Provider.of<Provider_Primary>(context,
                              //             listen: false)
                              //         .createSalesOrder(context: context);
                              //   },
                              // ),
                              PopupMenuItem(
                                child: 
                                onTap: 
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ),
                ),
              ),*/