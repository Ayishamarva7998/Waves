import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:waves/Utilities/providers/Printer/printer_provider.dart';
import 'package:intl/intl.dart';

class PrinterWidget extends StatelessWidget {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  ReceiptController? receiptController;

  @override
  Widget build(BuildContext context) {
    var bluetoothProvider = Provider.of<BluetoothProvider>(context);

    // Calculate total price
    double totalPrice = bluetoothProvider.items.entries.fold(0.0, (sum, entry) {
      double itemTotal = double.parse(entry.value['quantity']!) * double.parse(entry.value['price']!);
      return sum + itemTotal;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 23, 106, 144),
        appBar: AppBar(
          title: const Text(
            "Bluetooth Print",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 23, 106, 144),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  bluetoothProvider.connected
                      ? bluetoothProvider.disconnect()
                      : bluetoothProvider.connectToDevice();
                },
                child: CircleAvatar(
                  backgroundColor: bluetoothProvider.connected
                      ? const Color.fromARGB(255, 93, 171, 235)
                      : Colors.transparent,
                  child: const Icon(
                    Icons.bluetooth_connected_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: DropdownButton<BluetoothDevice>(
                  hint: const Text(
                    "Device",
                    style: TextStyle(color: Colors.blue),
                  ),
                  value: bluetoothProvider.selectedDevice,
                  onChanged: (BluetoothDevice? value) {
                    bluetoothProvider.setSelectedDevice(value);
                  },
                  items: bluetoothProvider.devices
                      .map((device) => DropdownMenuItem(
                            value: device,
                            child: Text(
                              device.name ?? "",
                              style: const TextStyle(color: Colors.amber),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: itemNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Item Name",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 185, 184, 184)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: itemQuantityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Quantity",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 185, 184, 184)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: itemPriceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Price",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 185, 184, 184)),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  bluetoothProvider.addItem(
                    itemNameController.text.trim(),
                    itemQuantityController.text.trim(),
                    itemPriceController.text.trim(),
                  );
                  itemNameController.clear();
                  itemQuantityController.clear();
                  itemPriceController.clear();
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Receipt(
                    backgroundColor: Colors.white,
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cobnm', // Add the company name here
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date: $currentDate',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(1), // Serial No
                            1: FlexColumnWidth(1), // Item Name
                            2: FlexColumnWidth(1), // Quantity
                            3: FlexColumnWidth(1), // Price
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'S.No',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Item Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Qty',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Price',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                            ...bluetoothProvider.items.entries.map((entry) {
                              int index = bluetoothProvider.items.keys
                                      .toList()
                                      .indexOf(entry.key) +
                                  1;
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text('$index'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(entry.key),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(entry.value['quantity']!),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(entry.value['price']!),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(thickness: 2),
                        Text(
                          'Total: \$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onInitialized: (controller) {
                      receiptController = controller;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: bluetoothProvider.connected
                      ? () => bluetoothProvider.printReceipt(receiptController)
                      : null,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 75, 231, 245),
                    ),
                    child: const Center(
                      child: Text(
                        "Print Receipt",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
