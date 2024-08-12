import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waves/UI/screens/Leave/addLeave.dart';
import 'package:waves/Utilities/Functions/commonFunctions.dart';
import 'package:waves/Utilities/providers/Leave/leave.dart';

class Screen_viewLeave extends StatefulWidget {
  @override
  State<Screen_viewLeave> createState() => _Screen_viewLeaveState();
}

class _Screen_viewLeaveState extends State<Screen_viewLeave> {
  void initState() {
    Provider.of<Provider_Leave>(context, listen: false).getLeaveList(
      context: context,
    );
    super.initState();
  }

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
        title: Text(
          "LEAVE APPLICATION",
          style: theme.textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
              height: 180,
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 13),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Expanded(
                        flex: 3,
                        child: Consumer<Provider_Leave>(
                            builder: (context, leave, child) {
                          return TextField(
                            controller: leave.fromDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'From',
                              // border: OutlineInputBorder()
                            ),
                            onTap: () async {
                              var picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 365)),
                                  lastDate: DateTime.now());
                              if (picked != null &&
                                  WaveFunctions().reverseDate(
                                          date: picked
                                              .toString()
                                              .substring(0, 10)) !=
                                      leave.fromDateController.text) {
                                leave.setFromDateController(
                                    date: picked.toString().substring(0, 10));
                              }
                            },
                          );
                        }),
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Expanded(
                        flex: 3,
                        child: Consumer<Provider_Leave>(
                            builder: (context, leave, child) {
                          return TextFormField(
                            controller: leave.toDateController,
                            readOnly: true,
                            decoration: InputDecoration(labelText: 'To'),
                            onTap: () async {
                              var picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 365)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 30)));

                              if (picked != null &&
                                  WaveFunctions().reverseDate(
                                          date: picked
                                              .toString()
                                              .substring(0, 10)) !=
                                      leave.toDateController.text) {
                                leave.setToDateController(
                                    date: picked.toString().substring(0, 10));
                              }
                            },
                          );
                        }),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(18)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // primary: Colors.blue[50],
                          ),
                      onPressed: () async {},
                      child: Text("APPLY"))
                ],
              )),
          Consumer<Provider_Leave>(builder: (context, leave, child) {
            return Container(
              height: 420,
              child: leave.isEmptyList
                  ? Container(
                      child: Center(child: Text('No leaves on this Period')),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          height: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(WaveFunctions().reverseDate(
                                      date: leave.leaves[index].leaveDate
                                          .toString())),
                                  Text('${leave.leaves[index].leaveType}')
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Provider.of<Provider_Leave>(context,
                                            listen: false)
                                        .getLeaveList(
                                      context: context,
                                    );
                                  },
                                  child: Text('${leave.leaves[index].status}',
                                      style: TextStyle(
                                          color: leave.leaves[index].isApproved!
                                              ? Colors.lightGreen
                                              : Colors.red)))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: leave.leaves.length),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Add LEAVE',
        child: Icon(
          Icons.add,
          color: Colors.blue,
          size: 30,
        ),
        onPressed: () async {
          Provider.of<Provider_Leave>(context, listen: false).salesPerson;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Screen_AddLeave(),
          ));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29),
          side: BorderSide(color: Colors.blue, width: 1.0),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
