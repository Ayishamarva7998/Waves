import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/widgets/CommonWidgets/wavesWidgets.dart';
import 'package:waves/UI/widgets/Order/invoicelist.dart';
import 'package:waves/UI/widgets/Order/salesorderList.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';

class Screen_CustomerHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors().backgroundColor,
      appBar: AppBar(
        // foregroundColor: Colors.white,
        // backgroundColor: Color.fromARGB(255, 24, 51, 150),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("HISTORY"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Tab(
                            text: 'SALES ORDER',
                          )),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Tab(text: 'INVOICE')),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Consumer<Provider_Primary>(
                            builder: (context, primary, child) {
                          return Stack(
                            children: [
                              // primary.isLoading ? Widget_Loading() :
                              Widget_SalesOrderList(),
                            ],
                          );
                        }),
                        Consumer<Provider_Primary>(
                            builder: (context, value, child) {
                          return Stack(
                            children: [
                              // value.isLoading ? Widget_Loading() :
                              Widget_InvoiceList(),
                            ],
                          );
                        })
                      ],
                    ),
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
}
