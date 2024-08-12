import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Models/Data/History/salesorder.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/Order/history.dart';

class Widget_SalesOrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<Provider_Primary>(builder: (context, primary, child) {
      return primary.customerOrderHistoryList.isEmpty
          ? Center(
              child: Text('No Orders Found'),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                var order = primary.customerOrderHistoryList[index];
                bool showPaymentButton =
                    order.status.toString().toLowerCase() ==
                        "To Deliver and Bill".toLowerCase();
                return GestureDetector(
                  onTap: () async {
                    Provider_History history =
                        Provider.of<Provider_History>(context, listen: false);
                    history.salesOrder = SalesOrder();
                    history.salesOrder!.salesOrderId = order.name;
                    history.salesOrder!.amount = order.amount;
                    history.salesOrder!.salesOrderDate = WaveFunctions()
                        .reverseDate(date: order.orderDate.toString());
                    history.status = order.status;
                    primary.salesOrderID = order.name;
                    await Provider.of<Provider_Primary>(context, listen: false)
                        .get_Customer_OrderDetails(
                      context: context,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    height: screenHeight * .15,
                    color: Colors.white,
                    child: Row(
                      children: [
                        // SizedBox(width: 4),
                        Expanded(
                          // flex: 2,
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: Image.asset(
                                "assets/images/orders.png",
                                height: 39,
                                width: 39,
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(
                              //   height: 14,
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'OrderID',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ':',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      ' ${order.name}',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Order Date',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ':',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      ' ${WaveFunctions().reverseDate(date: order.orderDate.toString())}',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Amount',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ':',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      ' ${order.amount}',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Status',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ':',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      ' ${order.status}',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme
                                                  .textTheme.bodySmall!.color),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // if (showPaymentButton)
                        //   Expanded(
                        //     flex: 3,
                        //     child: TextButton(
                        //         onPressed: () {
                        //           // Navigator.of(context).push(
                        //           //   MaterialPageRoute(
                        //           //     builder: (context) =>
                        //           //         Screen_Payment_Invoice_sales(
                        //           //       amount: order.amount.toString(),
                        //           //       id: order.name,
                        //           //       date: order.orderDate.toString(),
                        //           //       source: 'sales',
                        //           //     ),
                        //           //   ),
                        //           // );
                        //         },
                        //         child: Text(
                        //           "Payment",
                        //         )),
                        //   )
                        // else
                        //   Expanded(flex: 3, child: SizedBox()),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 5,
                  thickness: 2,
                );
              },
              itemCount: primary.customerOrderHistoryList.length,
            );
    });
  }
}
