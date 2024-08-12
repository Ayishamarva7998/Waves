import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Order/Primarysales.dart';

class Widget_InvoiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<Provider_Primary>(builder: (context, primary, child) {
      return primary.invoiceHistoryList.isEmpty
          ? Center(
              child: Text('No Invoices Found'),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                var invoice = primary.invoiceHistoryList[index];
                bool showPaymentButton =
                    (invoice.status == "Overdue" || invoice.status == 'Unpaid');
                return GestureDetector(
                  onTap: () async {
                    primary.invoiceID = invoice.name;
                    await Provider.of<Provider_Primary>(context, listen: false)
                        .get_Customer_InvoiceDetails(
                      context: context,
                    );
                  },
                  child: Container(
                    // height: screenHeight * .15,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(10),
                            child: Center(
                                child: Image.asset("assets/images/bill.png")),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(
                              //     height: MediaQuery.of(context).size.height * .01),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Invoice No',
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
                                    flex: 8,
                                    child: Text(
                                      ' ${invoice.name}',
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
                                    flex: 4,
                                    child: Text(
                                      'Invoice Date',
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
                                    flex: 8,
                                    child: Text(
                                      ' ${WaveFunctions().reverseDate(date: invoice.posting_date.toString())}',
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
                                    flex: 4,
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
                                    flex: 8,
                                    child: Text(
                                      ' ${invoice.total}',
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
                              // Text(
                              //   '          :  ',
                              //   style: theme.textTheme.bodySmall!.copyWith(
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 13,
                              //       color: theme.textTheme.bodySmall!.color),
                              // ),
                            ],
                          ),
                        ),
                        showPaymentButton
                            ? Expanded(
                                flex: 2,
                                child: GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         Screen_Payment_Invoice_sales(
                                      //       amount: invoice.total.toString(),
                                      //       id: invoice.name,
                                      //       date: reverseDate(
                                      //           date: invoice.posting_date.toString()),
                                      //       source: 'invoice',
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: Text(
                                      "Payment",
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: theme.primaryColor),
                                    )),
                              )
                            : Expanded(
                                flex: 2,
                                child: SizedBox(
                                  child: Text(invoice.status,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Colors.green)),
                                )),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  height: 3,
                  thickness: 2,
                );
              },
              itemCount: primary.invoiceHistoryList.length);
    });
  }
}
//http.Response response = await http.get('http://www.africau.edu/images/default/sample.pdf');
// var pdfData = response.bodyBytes;
// await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);//