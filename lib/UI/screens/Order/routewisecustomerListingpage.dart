import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:waves/UI/screens/Order/ItemdisplayPage.dart';
import 'package:waves/UI/screens/Order/customerPayment.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/Order/payment.dart';

class Screen_RouteMapCustomerList extends StatelessWidget {
  const Screen_RouteMapCustomerList({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: WavesWidgets().commonAppBar(text: 'customers', context: context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Column(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(1, 1),
                                color: const Color(0xFF000000).withOpacity(0.4),
                                blurRadius: 1,
                                spreadRadius: 1),
                          ]),
                      child: Consumer<Provider_Primary>(
                        builder: (context, primary, child) => DropdownButton(
                          underline: Container(),
                          hint: Center(
                            child: Text('Select Route',
                                style: theme.textTheme.bodySmall),
                          ),
                          isExpanded: true,
                          items: primary.routes
                              .map(
                                (e) => DropdownMenuItem(
                                    value: e,
                                    child: Center(
                                      child: Text('$e'.toUpperCase(),
                                          style: theme.textTheme.bodySmall),
                                    )),
                              )
                              .toList(),
                          onChanged: (value) {
                            primary.setSelectedRoute(
                                context: context, route: value.toString());
                          },
                          value: primary.selectedRoute,
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 10,
                  child: Consumer<Provider_Primary>(
                    builder: (context, primary, child) {
                      return ListView.builder(
                        itemCount: primary.customerMaster.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = primary.customerMaster[index];

                          return TimelineTile(
                            alignment: TimelineAlign.start,
                            // lineXY: 0.01,
                            isFirst: index == 0,
                            isLast: index == primary.customerMaster.length,
                            indicatorStyle: IndicatorStyle(
                              width: 40,
                              height: 40,
                              indicator: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.primary
                                          .withOpacity(.5)),
                                  child: Center(child: Text('${index + 1}'))),
                              drawGap: true,
                            ),
                            afterLineStyle: LineStyle(
                                color: index ==
                                        primary.customerMaster.length - 1
                                    ? Colors.transparent
                                    : const Color.fromARGB(255, 104, 224, 162)),
                            beforeLineStyle: const LineStyle(
                              color: Color.fromARGB(255, 104, 206, 224),
                            ),
                            endChild: Container(
                              // decoration: BoxDecoration(border: Border.all()),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(
                                    '${data.customer}',
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(screenWidth * .01),
                                          child: Consumer<Provider_Item>(
                                              builder: (context, item, child) {
                                            return GestureDetector(
                                                onTap: () async {
                                                  primary.setLoading();
                                                  primary.setSelectedCustomer(
                                                      name: data.customer!,
                                                      code:
                                                          data.customer_code ??=
                                                              data.customer!);
                                                  await item.getItemMaster(
                                                      context: context);
                                                  primary.finishLoading();
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Screen_ItemDiaplay(
                                                                isedit: false,
                                                              )));
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          screenHeight * .01,
                                                    ),
                                                    // alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 238, 243, 246),
                                                      border: Border.all(
                                                        color: Color.fromARGB(
                                                            255, 238, 243, 246),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Order',
                                                        style: theme.textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          color: Color.fromARGB(
                                                              255, 1, 137, 179),
                                                        ),
                                                        // textAlign: TextAlign.end,
                                                      ),
                                                    )));
                                          }),
                                        ),
                                      ),
                                      Expanded(
                                        // flex: 2,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(screenWidth * .01),
                                          child: GestureDetector(
                                              onTap: () async {
                                                primary.setLoading();
                                                await primary
                                                    .setSelectedCustomer(
                                                        name: data.customer!,
                                                        code:
                                                            data.customer_code ??
                                                                data.customer!);
                                                await Provider.of<
                                                            Provider_Payment>(
                                                        context,
                                                        listen: false)
                                                    .setPaymentdefault(
                                                        context: context);
                                                primary.finishLoading();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Screen_payment()));
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        screenHeight * .01,
                                                  ),
                                                  // alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 238, 243, 246),
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 238, 243, 246),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Payment',
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                      color: Color.fromARGB(
                                                          255, 1, 137, 179),
                                                    ),
                                                  )))),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(screenWidth * .01),
                                          child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        screenHeight * .01,
                                                  ),
                                                  // alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 238, 243, 246),
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 238, 243, 246),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    'Visit',
                                                    style: theme
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                      color: Color.fromARGB(
                                                          255, 1, 137, 179),
                                                    ),
                                                  )))),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(screenWidth * .01),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: screenHeight * .01,
                                              ),
                                              // alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 238, 243, 246),
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 238, 243, 246),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Map',
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                    color: Color.fromARGB(
                                                        255, 1, 137, 179),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      // return ListView.builder(
                      //   itemBuilder: (context, index) {
                      //     var data = primary.customerMaster[index];
                      //     return Container(
                      //       height: 60,
                      //       color: Colors.green,
                      //       child: Text('${data.customer}'),
                      //     );
                      //   },
                      //   itemCount: primary.customerMaster.length,
                      // );
                    },
                  ),
                )
              ]),
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
      ),
    );
  }
}
