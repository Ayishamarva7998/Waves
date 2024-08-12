import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/screens/Order/AddCustomer.dart';
import 'package:waves/UI/screens/Order/ItemdisplayPage.dart';
import 'package:waves/UI/screens/Order/customerpage.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/constants/colors.dart';

class Screen_CustomerList extends StatefulWidget {
  const Screen_CustomerList({super.key});

  @override
  State<Screen_CustomerList> createState() => _Screen_CustomerListState();
}

class _Screen_CustomerListState extends State<Screen_CustomerList> {
  @override
  void initState() {
    getinitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: WavesWidgets().commonAppBar(text: 'customers', context: context),
      body: SafeArea(
        child: Column(children: [
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                // height: 35,
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
                    onChanged: (value) async {
                      await primary.setSelectedRoute(
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
            flex: 20,
            child: Consumer<Provider_Primary>(
              builder: (context, primary, child) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                  itemCount: primary.customerMaster.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = primary.customerMaster[index];
                    return GestureDetector(
                      onTap: () async {
                        primary.setSelectedCustomer(
                            name: data.customer!,
                            code: data.customer_code ?? data.customer!);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Screen_CustomerPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .01,
                            vertical: screenHeight * .01),
                        height: screenHeight * .1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Container(
                          // margin: EdgeInsets.symmetric(
                          //     vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data.customer}',
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              color: WaveColors.textColor),
                                    ),
                                    SizedBox(height: 3),
                                    Text('${data.contact}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () async {
                                    primary.setSelectedCustomer(
                                        name: data.customer!,
                                        code: data.customer_code ??
                                            data.customer!);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Screen_ItemDiaplay(isedit: false),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add_shopping_cart_sharp,
                                    color: Color.fromRGBO(122, 122, 122, 1),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Padding(padding: EdgeInsets.all(screenHeight * .01)),
                );
              },
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Screen_AddCustomer()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void getinitialized() async {
    await Provider.of<Provider_Item>(context, listen: false)
        .getItemMaster(context: context);
    await Provider.of<Provider_Item>(context, listen: false)
        .getCustomerOrderList(context: context);
  }
}
