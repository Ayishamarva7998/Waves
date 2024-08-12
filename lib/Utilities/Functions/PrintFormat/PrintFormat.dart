import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:waves/Models/Data/Invoice/invoicedetails.dart';

class PrintFormat {
 List<LineText>  createPrint({required InvoiceData invoice}) {
    List<LineText> printdata = [];
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '**********************************************',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${invoice.customer}',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        fontZoom: 2,
        linefeed: 1));
    printdata.add(LineText(linefeed: 1));

    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '-----------------------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${DateTime.now()}',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Invoice No',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 350,
        relativeX: 0,
        linefeed: 0));
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Invoice date',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        x: 500,
        relativeX: 0,
        linefeed: 1));

    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Amount',
        align: LineText.ALIGN_LEFT,
        x: 0,
        relativeX: 0,
        linefeed: 0));
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'ABCDEFG',
        align: LineText.ALIGN_LEFT,
        x: 350,
        relativeX: 0,
        linefeed: 0));
    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'HIJKL',
        align: LineText.ALIGN_LEFT,
        x: 500,
        relativeX: 0,
        linefeed: 1));

    printdata.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '**********************************************',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    printdata.add(LineText(linefeed: 1));
    for (var item in invoice.items!) {
      printdata.add(
          LineText(type: LineText.TYPE_TEXT, x: 10, y: 10, content: 'A Title'));
      printdata.add(LineText(
          type: LineText.TYPE_TEXT, x: 10, y: 40, content: 'this is content'));
      printdata.add(LineText(
          type: LineText.TYPE_QRCODE, x: 10, y: 70, content: 'qrcode i\n'));
      printdata.add(LineText(
          type: LineText.TYPE_BARCODE, x: 10, y: 190, content: 'qrcode i\n'));
    }
    return printdata;
  }
}
