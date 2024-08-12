import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/Location/locationServices.dart';
import 'package:waves/UI/screens/Order/ItemdisplayPage.dart';
import 'package:waves/UI/screens/Order/customerHistorypage.dart';
import 'package:waves/UI/screens/Order/customerPayment.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/UI/widgets/Order/creditView.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';
import 'package:waves/Utilities/providers/Order/payment.dart';

class Screen_CustomerPage extends StatelessWidget {
  List<Map<String, dynamic>> gridViewItems = [];
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    getGridViewItems();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // foregroundColor: Colors.white,
        // backgroundColor: AppColors().appBar,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Consumer<Provider_Primary>(
            builder: (context, primary, child) =>
                Text('${primary.selectedCustomerCode}'.toUpperCase())),
        centerTitle: true,
        //
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .01),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                Widget_CreditView(),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                GridView.builder(
                  itemCount: gridViewItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: grid(context: context, index: index),
                        onTap: () async {
                          if (index != 2) {
                            await initializeFunctions(
                                index: index, context: context);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      gridViewItems[index]['page']),
                            );
                          }
                        });
                  },
                  shrinkWrap: true,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .01),
                // Widget_Ledger_Recivable(),
                SizedBox(height: MediaQuery.of(context).size.height * .02),
                // Widget_creditLimit(),
                SizedBox(height: MediaQuery.of(context).size.height * .01),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child:
                Consumer<Provider_Primary>(builder: (context, primary, child) {
              return Visibility(
                  visible: primary.isLoading,
                  child: WavesWidgets().loadingWidget(context: context));
            }),
          ),
        ],
      ),
    );
  }

  Padding grid({required BuildContext context, required int index}) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   width: 12,
            // ),
            Expanded(
              flex: 2,
              child: Image.asset(
                gridViewItems[index]['img'],
                height: 31,
                width: 31,
              ),
            ),
            // SizedBox(width: 13),
            Expanded(
              child: Text(
                gridViewItems[index]['text'],
                textAlign: TextAlign.start,
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getGridViewItems() {
    gridViewItems = [
      {
        "text": 'Invoice',
        "img": "assets/images/cart.png",
        "page": Screen_ItemDiaplay(isedit: false),
      },
      {
        "text": 'Payment',
        "img": "assets/images/payment.png",
        "page": Screen_payment(),
      },
      {
        "text": 'Visit',
        "img": "assets/images/visit.png",
        // "page": Screen_ItemDiaplay(isedit: false),
      },
      // {
      //   "text": 'Sales Return',
      //   "img": 'assets/Images/return.png',
      //   "page":Screen_ItemDiaplay(isedit: false),
      // },
      {
        "text": 'History',
        "img": 'assets/images/history.png',
        "page": Screen_CustomerHistory(),
      }
    ];
  }

  Future initializeFunctions(
      {required index, required BuildContext context}) async {
    switch (index) {
      case 0:
        {
          Provider.of<Provider_Primary>(context, listen: false).setLoading();
          await Provider.of<Provider_Item>(context, listen: false)
              .getItemMaster(context: context);
          await Provider.of<LocationServices>(context, listen: false)
              .watchuserLocation();
          Provider.of<Provider_Item>(context, listen: false)
              .customerOrderList
              .clear();
          Provider.of<Provider_Primary>(context, listen: false).finishLoading();
        }
      case 1:
        {
          await Provider.of<Provider_Payment>(context, listen: false)
              .setPaymentdefault(context: context);
        }
      case 3:
        {
          //     await Provider.of<Provider_Item>(context, listen: false)
          //         .getItemMaster(context: context);
          //   }
          // case 3:
          //   {
          await Provider.of<Provider_Primary>(context, listen: false)
              .get_customer_OrderHistory(
            context: context,
          );
          await Provider.of<Provider_Primary>(context, listen: false)
              .getInvoices(context: context);
        }
    }
  }
}
