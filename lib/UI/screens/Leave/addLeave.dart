import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Leave/leave.dart';
import 'package:waves/Utilities/providers/SalesPerson/salesperson.dart';

class Screen_AddLeave extends StatefulWidget {
  @override
  State<Screen_AddLeave> createState() => _Screen_AddLeaveState();
}

class _Screen_AddLeaveState extends State<Screen_AddLeave> {
  DateTime? fpicked, tpicked;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text("LEAVE FORM"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView(
          children: [
            Consumer<Provider_SalesPerson>(builder: (context, person, child) {
              return Container(
                alignment: Alignment.centerLeft,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${person.name}',
                  style: theme.textTheme.bodySmall,
                ),
              );
            }),
            Padding(padding: EdgeInsets.all(9)),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Consumer<Provider_Leave>(
                        builder: (context, leave, child) {
                      return TextFormField(
                        readOnly: true,
                        controller: leave.fromDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          label: Text('From date'),
                          suffixIcon: IconButton(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                              onPressed: () async {
                                fpicked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 30)),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 60)));
                                if (fpicked != null &&
                                    WaveFunctions().reverseDate(
                                            date: fpicked
                                                .toString()
                                                .substring(0, 10)) !=
                                        leave.fromDateController.text) {
                                  leave.fromDateController.text =
                                      (WaveFunctions().reverseDate(
                                          date: fpicked
                                              .toString()
                                              .substring(0, 10)));
                                  tpicked = fpicked;
                                  leave.toDateController.text = WaveFunctions()
                                      .reverseDate(
                                          date: fpicked
                                              .toString()
                                              .substring(0, 10));
                                }
                                if (fpicked == null) {
                                  fpicked = DateTime.now();
                                }
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.blue,
                              )),
                        ),
                      );
                    })),
              ],
            ),
            Padding(padding: EdgeInsets.all(9)),
            Row(children: [
              Expanded(
                  flex: 3,
                  child: Consumer<Provider_Leave>(
                      builder: (context, leave, child) {
                    return TextFormField(
                      readOnly: true,
                      controller: leave.toDateController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          label: Text('To date'),
                          suffixIcon: IconButton(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                              onPressed: () async {
                                tpicked = await showDatePicker(
                                    context: context,
                                    initialDate: fpicked,
                                    firstDate: DateTime.now()
                                        .subtract(Duration(days: 30)),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 60)));
                                if (tpicked != null &&
                                    tpicked != leave.toDateController.text) {
                                  leave.toDateController.text = (WaveFunctions()
                                      .reverseDate(
                                          date: tpicked
                                              .toString()
                                              .substring(0, 10)
                                              .trim()));
                                }
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.blue,
                              ))),
                    );
                  })),
            ]),
            Padding(padding: EdgeInsets.all(9)),
            Container(
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
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child:
                    Consumer<Provider_Leave>(builder: (context, leave, child) {
                  return DropdownButton(
                    underline: Container(),
                    hint: Center(child: Text('Select Leave Type')),
                    isExpanded: true,
                    items: leave.leaveType
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  Expanded(child: Center(child: Text(e))),
                                ],
                              ),
                              alignment: Alignment.center,
                            ))
                        .toList(),
                    onChanged: (value) {
                      leave.selectedLeave = value.toString();
                      leave.notifyListeners();
                    },
                    value: leave.selectedLeave,
                  );
                })),
            Padding(padding: EdgeInsets.all(9)),
            Consumer<Provider_Leave>(builder: (context, leave, child) {
              return TextFormField(
                controller: leave.reasonController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    hintText: 'Reason'),
              );
            }),
            Padding(padding: EdgeInsets.all(7)),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.blue[50],
                    minimumSize: Size(200, 40),
                  ),
                  onPressed: () async {
                    Provider.of<Provider_Leave>(context, listen: false)
                        .requestButtonPressed(
                      context: context,
                    );
                  },
                  child: Text("REQUEST"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
