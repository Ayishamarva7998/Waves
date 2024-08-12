import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';

class BluetoothProvider with ChangeNotifier {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _connected = false;
  Map<String, Map<String, String>> items = {}; // Holds quantity and price

  BluetoothProvider() {
    initBluetooth();
  }

  List<BluetoothDevice> get devices => _devices;
  BluetoothDevice? get selectedDevice => _selectedDevice;
  bool get connected => _connected;

  Future<void> initBluetooth() async {
    try {
      bool? isAvailable = await bluetooth.isAvailable;
      bool? isOn = await bluetooth.isOn;

      if (!isAvailable! || !isOn!) {
        print("Bluetooth is not available or not turned on.");
        return;
      }

      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      _devices = devices;
      notifyListeners();

      bluetooth.onStateChanged().listen((state) {
        _connected = state == BlueThermalPrinter.CONNECTED;
        notifyListeners();
      });
    } catch (e) {
      print("Error initializing Bluetooth: $e");
    }
  }

  void setSelectedDevice(BluetoothDevice? device) {
    _selectedDevice = device;
    notifyListeners();
  }

  void connectToDevice() {
    if (_selectedDevice != null) {
      bluetooth.connect(_selectedDevice!).catchError((error) {
        _connected = false;
        notifyListeners();
      });
    }
  }

  void disconnect() {
    bluetooth.disconnect();
    _connected = false;
    notifyListeners();
  }

  void addItem(String name, String quantity, String price) {
    items[name] = {'quantity': quantity, 'price': price};
    notifyListeners();
  }

  // Method to calculate total price
  double getTotalPrice() {
    return items.entries.fold(0.0, (sum, entry) {
      double itemTotal = double.parse(entry.value['quantity']!) * double.parse(entry.value['price']!);
      return sum + itemTotal;
    });
  }

  void printReceipt(ReceiptController? receiptController) {
    if (_connected) {
      bluetooth.printNewLine();
      bluetooth.printCustom("CLASSIC PAINT ROLLERS AND ALLIED PRODUCTS", 3, 1);
      bluetooth.printNewLine();

      int index = 1;
      double total = 0.0;

      items.forEach((key, value) {
        double itemTotal =
            double.parse(value['quantity']!) * double.parse(value['price']!);
        total += itemTotal;

        bluetooth.printCustom(
            "$index. $key  Qty: ${value['quantity']}  Price: ${value['price']}",
            1,
            0);
        index++;
      });

      bluetooth.printNewLine();
      bluetooth.printCustom("Total: \$${total.toStringAsFixed(2)}", 2, 1);
      bluetooth.printNewLine();
      bluetooth.printNewLine();
    }
  }
}
