import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Services/DataBase/localdb.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/Utilities/providers/Order/Item.dart';

class Widget_Profile extends StatelessWidget {
  const Widget_Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("PROFILE", style: theme.textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Container(
                height: screenHeight * .1,
                decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border.all(color: theme.canvasColor),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(1, 2),
                          color: theme.shadowColor.withOpacity(.5))
                    ],
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Expanded(
                        child: Icon(Icons
                            .signal_cellular_connected_no_internet_0_bar_outlined)),
                    Expanded(
                        flex: 8,
                        child: Text(
                          'Offline orders',
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                    Expanded(child: Consumer<Provider_Item>(
                        builder: (context, item, child) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: Icon(Icons.sync),
                            onPressed: () {
                              item.syncoflineData();
                            },
                          ),
                          Text(
                            textAlign: TextAlign.right,
                            '${item.oflineordercount}',
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        ],
                      );
                    })),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Consumer<Provider_Item>(builder: (context, item, child) {
                return GestureDetector(
                    child: Container(
                      height: screenHeight * .1,
                      decoration: BoxDecoration(
                          color: theme.cardColor,
                          border: Border.all(color: theme.canvasColor),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                offset: Offset(1, 2),
                                color: theme.shadowColor.withOpacity(.5))
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          const Expanded(child: Icon(Icons.logout)),
                          Expanded(
                              flex: 8,
                              child: Text(
                                'LogOut',
                                style: theme.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )),
                          const Expanded(child: Icon(CupertinoIcons.forward)),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (item.oflineordercount <= 0) {
                        await LocalStorage().logout(context);
                      } else {
                        WavesWidgets().toastMessage(
                            context: context,
                            message: 'You have ofline orders to sync');
                      }
                    });
              })
            ],
          ))
        ],
      ),
    );
  }
}
