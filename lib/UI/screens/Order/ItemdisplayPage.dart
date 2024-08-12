import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Api/ApiServices.dart';
import 'package:waves/UI/screens/Order/newOrderDetails.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/constants/colors.dart';

class Screen_ItemDiaplay extends StatefulWidget {
  bool isedit;
  Screen_ItemDiaplay({super.key, required this.isedit});

  @override
  State<Screen_ItemDiaplay> createState() => _Screen_ItemDiaplayState();
}

class _Screen_ItemDiaplayState extends State<Screen_ItemDiaplay>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? customerName, customercode;
  late Provider_Primary primary;
  @override
  void initState() {
    syncoflineOrder();
    primary = Provider.of<Provider_Primary>(context, listen: false);
    tabController = TabController(
        length: Provider.of<Provider_Item>(context, listen: false)
            .itemGroups
            .length,
        vsync: this);
    if (!widget.isedit) {
      navigate(context: context, customer: customercode);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      DefaultTabController(
        length: 10,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: AppColors().backgroundColor,
          appBar: AppBar(
            // backgroundColor: AppColors().appBar,
            // foregroundColor: Colors.white,
            centerTitle: true,
            title: Text("ADD ITEMS"),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 15,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .1,
                      child: Consumer<Provider_Item>(
                          builder: (context, item, child) {
                        return TabBar(
                          controller: tabController,
                          labelPadding: EdgeInsets.all(10),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: item.itemGroups,
                        );
                      }),
                    ),
                    Container(
                      color: WaveColors.liteBlue.withOpacity(.6),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Center(
                                  child: Text('Item',
                                      style: theme.textTheme.titleSmall))),
                          Expanded(child: SizedBox()),
                          Expanded(
                              child: Center(
                                  child: Text(
                            'Rate',
                            style: theme.textTheme.titleSmall,
                          ))),
                          Expanded(child: SizedBox()),
                          Expanded(
                              child: Center(
                                  child: Text(
                            'Qty',
                            style: theme.textTheme.titleSmall,
                          ))),
                          Expanded(child: SizedBox()),
                          Expanded(
                              child: Center(
                                  child: Text(
                            'Amount',
                            style: theme.textTheme.titleSmall,
                          )))
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .02,
                            vertical: screenHeight * .02),
                        height: screenHeight * .1,
                        child: Consumer<Provider_Item>(
                            builder: (context, item, child) {
                          return TextFormField(
                              controller: item.itemSearch,
                              style: theme.textTheme.bodySmall,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                  hintText: 'Search Item',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: item.itemSearch.text == ''
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            item.itemSearch.text = '';
                                            item.getItemByGroup(
                                                itemgroup: item
                                                    .itemGroups[
                                                        tabController.index]
                                                    .text
                                                    .toString(),
                                                theme: theme);
                                            item.notifyListeners();
                                          },
                                          icon: Icon(Icons.close))),
                              onChanged: (value) {
                                item.getItemByGroup(
                                    itemgroup: item
                                        .itemGroups[tabController.index].text
                                        .toString(),
                                    theme: theme);
                                item.notifyListeners();
                              });
                        })),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.height * .1,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       ValueListenableBuilder(
                    //         valueListenable: total,
                    //         builder: (context, value, child) {
                    //           return Padding(
                    //             padding: const EdgeInsets.only(right: 11, bottom: 7),
                    //             child: Text(
                    //               'TOTAL   :   ₹${total.value}',
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: MediaQuery.of(context).size.height * .55,
                      child: Consumer<Provider_Item>(
                          builder: (context, item, child) {
                        return TabBarView(
                          controller: tabController,
                          children: List.generate(
                              item.itemGroups.length,
                              (index) => item.getItemByGroup(
                                  theme: theme,
                                  itemgroup:
                                      item.itemGroups[index].text.toString())),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Consumer<Provider_Item>(
                builder: (context, itemData, child) => ElevatedButton(
                  onPressed: () async {
                    Provider_Item item = await Provider.of<Provider_Item>(
                        context,
                        listen: false);
                    await item.addbuttonPressed(context: context);
                    if (!widget.isedit) {
                      if (item.customerOrderList.isEmpty) {
                        WavesWidgets().snackBarError(
                            context: context, message: 'Pleasee add items');
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Screen_AddedItems()));
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ADD"),
                      SizedBox(width: 5),
                      Icon(Icons.add),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
      //   ValueListenableBuilder(
      //     valueListenable: isLoading,
      //     builder: (context, value, child) =>
      //         isLoading.value ? App_Widgets().loadingWidget() : Container(),
      //   )
    ]);
  }

  void navigate({required BuildContext context, required customer}) async {
    var itemdata = Provider.of<Provider_Item>(context, listen: false);
    await itemdata.getCustomerOrderList(context: context).then((value) {
      if (itemdata.customerOrderList.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Screen_AddedItems()));
      } else {}
    });
  }

  void syncoflineOrder() async {
    await Provider.of<Provider_Item>(context, listen: false).syncoflineData();
  }
}
