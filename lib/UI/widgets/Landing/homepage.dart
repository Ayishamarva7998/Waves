import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/screens/Invoices/salesPersoninvoices.dart';
import 'package:waves/UI/screens/Leave/viewLeave.dart';
import 'package:waves/UI/screens/Order/customerListingpage.dart';
import 'package:waves/UI/screens/Order/routewisecustomerListingpage.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Home/home.dart';
import 'package:waves/Utilities/providers/Invoice/invoiceprovider.dart';
import 'package:waves/Utilities/providers/Leave/leave.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';
import 'package:waves/constants/colors.dart';

class Widget_Home extends StatelessWidget {
  const Widget_Home({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Provider.of<Provider_Home>(context, listen: false)
        .getAttendanceStatus(context: context);
    var theme = Theme.of(context);
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Container(
                    // color: Colors.green,
                    // padding: EdgeInsets.symmetric(horizontal: 5),
                    height: screenHeight * .3,
                    child: Stack(children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          height: screenHeight * .3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [WaveColors.primary, WaveColors.vilot],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            color: theme.colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(45)),
                          ),
                        ),
                      ),
                      // Positioned(
                      //     top: 0,
                      //     left: screenWidth * .45,
                      //     right: 0,
                      //     child: Image.asset(
                      //       height: screenHeight * .35,
                      //       'assets/images/salesperson.png',
                      //       fit: BoxFit.contain,
                      //     )),
                      Positioned(
                        top: screenHeight * .3 * .1,
                        left: screenWidth * .04,
                        right: screenWidth * .25,
                        child: Container(
                          // color: Colors.green,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<Provider_SalesPerson>(
                                  builder: (context, salesperson, child) {
                                return Text(
                                  'Hi ${salesperson.name}!',
                                  style: theme.textTheme.headlineLarge!
                                      .copyWith(
                                          color: theme.colorScheme.tertiary,
                                          fontWeight: FontWeight.bold),
                                );
                              }),
                              const Padding(padding: EdgeInsets.all(5)),
                              Text(
                                'Have A Nice Day!',
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          // child: RichText(
                          //   text: TextSpan(
                          //       style: theme.textTheme.headlineMedium!.copyWith(
                          //           color: theme.colorScheme.tertiary,
                          //           fontWeight: FontWeight.bold),
                          //       children: [
                          //         const TextSpan(text: 'Hi  '),
                          //         TextSpan(text: '${salesperson.name}!'),
                          //         TextSpan(
                          //             text: '\n\nHave A Nice Day',
                          //             style: theme.textTheme.bodyMedium!.copyWith(
                          //                 color: theme.colorScheme.tertiary))
                          //       ]),
                          // ),
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight * .3 * .15,
                        right: screenWidth * .2,
                        left: screenWidth * .2,
                        child: SizedBox(
                          width: screenWidth * .5,
                          height: screenHeight * .08,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Consumer<Provider_Home>(
                              builder: (context, home, child) {
                                return ElevatedButton(
                                    onPressed: () async {
                                      await home.checkIn(context: context);
                                    },
                                    child: Text(
                                      home.attendance > 0
                                          ? 'Check Out'
                                          : 'Check In',
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ));
                              },
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  // Container(
                  //   margin: EdgeInsets.all(10),
                  //   height: screenHeight * .25,
                  //   padding: EdgeInsets.all(15),
                  //   color: theme.colorScheme.primary,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: Colors.white,
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         'Notifications',
                  //         style: theme.textTheme.headlineMedium,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: screenHeight * .05,
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .05,
                        vertical: screenHeight * .03),
                    child: Text(
                      'Start Your Work',
                      style: theme.textTheme.titleMedium!.copyWith(
                          color: WaveColors.textColor.withOpacity(.4)),
                    ),
                  ),
                  Container(
                    height: 2 * screenHeight * .18,
                    padding: EdgeInsets.symmetric(
                        // vertical: screenHeight * .3 * .1,
                        horizontal: screenWidth * .03),
                    decoration: BoxDecoration(),
                    child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: screenWidth ~/ 120,
                        childAspectRatio: 1,
                        crossAxisSpacing: screenWidth * .05,
                        mainAxisSpacing: screenHeight * .05,
                        children: [
                          GestureDetector(
                              child: gridContainer(
                                  icon: 'assets/images/order.png',
                                  name: 'SALES',
                                  theme: theme),
                              onTap: () async {
                                await Provider.of<Provider_Primary>(context,
                                        listen: false)
                                    .getRouteList(context: context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const Screen_CustomerList()));
                              }),
                          GestureDetector(
                            child: gridContainer(
                                icon: 'assets/images/rout.png',
                                name: 'ROUTE SALES',
                                theme: theme),
                            onTap: () async {
                              await Provider.of<Provider_Primary>(context,
                                      listen: false)
                                  .getRouteList(context: context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const Screen_RouteMapCustomerList()));
                            },
                          ),
                          GestureDetector(
                            child: gridContainer(
                                icon: 'assets/images/invoice.png',
                                name: 'INVOICES',
                                theme: theme),
                            onTap: () async {
                              var primary = Provider.of<Provider_Primary>(
                                  context,
                                  listen: false);
                              primary.setLoading();
                              Provider_Invoice invoice =
                                  Provider.of<Provider_Invoice>(context,
                                      listen: false);
                              await invoice.getinvoicedefaults();
                              await invoice.getSalesPersonInvoiceList(
                                  context: context);
                              primary.finishLoading();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Screen_SalesPersonInvoices()));
                            },
                          ),
                          GestureDetector(
                            child: gridContainer(
                                icon: 'assets/images/calendar.png',
                                name: 'LEAVE',
                                theme: theme),
                            onTap: () async {
                              
                              // WavesWidgets().toastMessage(
                              //     context: context,
                              //     message: 'This Feature is not available');
                              // await Provider.of<Provider_Leave>(context,
                              //         listen: false)
                              //     .initialiseViewleaveDates(context: context);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => Screen_viewLeave()));
                            },
                          ),
                          GestureDetector(
                            child: gridContainer(
                                icon: 'assets/images/expense.png',
                                name: 'EXPENSE',
                                theme: theme),
                            onTap: () {
                              WavesWidgets().toastMessage(
                                  context: context,
                                  message: 'This Feature is not available');
                            },
                          ),
                          GestureDetector(
                              child: gridContainer(
                                  icon: 'assets/images/report.png',
                                  name: 'Reports',
                                  theme: theme),
                              onTap: () async {
                                WavesWidgets().toastMessage(
                                    context: context,
                                    message: 'This Feature is not available');
                              }),
                        ]),
                  ),
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

  Widget gridContainer(
      {required String icon, required String name, required ThemeData theme}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.2),
              offset: Offset(2, 5),
              blurRadius: 3)
        ],
        color: theme.colorScheme.tertiary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              icon,
              height: 40,
              width: 40,
            ),
            // child: Icon(
            //   icon,
            //   size: 35,
            // ),
          ),
          Expanded(child: SizedBox()),
          Expanded(
            flex: 2,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
