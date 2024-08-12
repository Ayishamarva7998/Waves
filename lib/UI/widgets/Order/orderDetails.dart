import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/constants/colors.dart';

// ignore: must_be_immutable
class NewOrderList extends StatelessWidget {
  ValueNotifier<double> total = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    // getTotal(context: context);
    var theme = Theme.of(context);
    var screenHeight = MediaQuery.of(context).size.height;
    return Consumer<Provider_Item>(
      builder: (context, itemdata, child) => Container(
        height: MediaQuery.of(context).size.height * .7,
        child: ListView.separated(
          itemCount: itemdata.customerOrderList.length,
          itemBuilder: (context, index) {
            var data = itemdata.customerOrderList[index];
            return Container(
              height: screenHeight * .15,
              padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Image.asset(
                      "assets/images/27002.jpg",
                      height: 45,
                      width: 45,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${data.itemName}',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: WaveColors.textColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(child: Text('${data.itemCode}')), //item code

                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: Text('Quantity')),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                                onTap: () {
                                                  String? customer;

                                                  customer = Provider.of<
                                                              Provider_Primary>(
                                                          context,
                                                          listen: false)
                                                      .selectedCustomerCode;

                                                  itemdata
                                                      .decrementItemCountFromCustomerList(
                                                          customerName:
                                                              customer!,
                                                          context: context,
                                                          index: index);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: Container(
                                                    height: screenHeight * .02,
                                                    width: screenHeight * .02,
                                                    decoration: BoxDecoration(),
                                                    child: Icon(Icons.remove),
                                                    // App_Widgets()
                                                    // .container(iconData: Icons.add),
                                                  ),
                                                )
                                                //  App_Widgets()
                                                //     .container(iconData: Icons.remove),
                                                ),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  '${data.itemQty ?? 0.toInt()}')),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                String? customer;

                                                customer = Provider.of<
                                                            Provider_Primary>(
                                                        context,
                                                        listen: false)
                                                    .selectedCustomerCode;

                                                itemdata
                                                    .incrementItemCountFromCustomerList(
                                                        customerName: customer!,
                                                        index: index);
                                              },
                                              child: Container(
                                                height: screenHeight * .02,
                                                width: screenHeight * .02,
                                                decoration: BoxDecoration(),
                                                child: Icon(Icons.add),
                                                // App_Widgets()
                                                // .container(iconData: Icons.add),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: Text("Amount")),
                                    Expanded(child: Text('${data.amount}'))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          String? customer;

                          customer = Provider.of<Provider_Primary>(context,
                                  listen: false)
                              .selectedCustomerCode;

                          itemdata.deleteItemFromCustomerOrder(
                              customerName: customer!,
                              index: index,
                              context: context);
                          itemdata.getTotalAmount();
                        },
                        icon: Icon(Icons.delete),
                        color: const Color.fromARGB(255, 237, 149, 143)),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 3, thickness: 2);
          },
        ),
      ),
    );
  }
}
