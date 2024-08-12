import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/constants/colors.dart';

class Screen_ViewSalesOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var data =
        Provider.of<Provider_Primary>(context, listen: false).salesOrderDetails;
    var theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios)),
          // actions: [
          //   PopupMenuButton(
          //     offset: Offset(0, kToolbarHeight),
          //     onSelected: (value) {
          //       if (value == 'menuItem1') {}
          //     },
          //     itemBuilder: (context) {
          //       return [
          //         PopupMenuItem(
          //           value: 'menu1',
          //           child: Text('Create Invoice'),
          //           onTap: () {
          //             // Provider.of<Provider_Primary>(context, listen: false)
          //             //     .createSalesInvoice(context: context);
          //           },
          //         ),
          //       ];
          //     },
          //   ),
          // ],
          title: Consumer<Provider_Primary>(builder: (context, primary, child) {
            return Text(primary.selectedCustomerName!.toUpperCase());
          }),
          centerTitle: true,
        ),
        body: Container(
          child: ListView(children: [
            SizedBox(height: screenHeight * .02),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              height: screenHeight * .2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(5, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Order Date',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            flex: 8,
                            child: Text(data.sales_orderDate.toString(),
                                style: theme.textTheme.bodySmall))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Advance Paid',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            flex: 8,
                            child: Text(data.advance_paid!.toString(),
                                style: theme.textTheme.bodySmall))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Text(
                              'Ref. No',
                              style: theme.textTheme.bodySmall,
                            )),
                        Expanded(
                          child: Text(':', style: theme.textTheme.bodySmall),
                        ),
                        Expanded(
                            flex: 8,
                            child: Text(data.sales_order_id.toString(),
                                style: theme.textTheme.bodySmall))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2),
                      height: 40,
                      child: Text(
                        "SL",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(.6)),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: Text(
                        "Item",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(.6)),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 40,
                      child: Text(
                        "Qty",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(.6)),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      height: 40,
                      child: Text(
                        "Rate",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(.6)),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(2),
                    height: 40,
                    child: Text(
                      "Amount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(.6)),
                  ),
                )
              ],
            ),
            SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.items!.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: ((context, index) {
                          var item = data.items![index];
                          return Container(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 48,
                                      padding: const EdgeInsets.all(2),
                                      child: Text('${index + 1}')),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Center(
                                          child: Text('${item.item_name}'))),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Text('${item.qty}'))),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 11),
                                        child: Text('${item.rate}'))),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: Text('${item.amount}')))
                              ],
                            ),
                          );
                        }))))
          ]),
        ));
  }
}
