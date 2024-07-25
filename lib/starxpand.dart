import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:star_printer/model.dart';
import 'package:starxpandprinter/starxpand.dart';

class PrintersPage extends StatefulWidget {
  const PrintersPage({Key? key}) : super(key: key);

  @override
  State<PrintersPage> createState() => _PrintersPageState();
}

class _PrintersPageState extends State<PrintersPage> {
  List<StarXpandPrinter>? printers;
  Uint8List? logoBytes;
  List<Product> products = [
    Product(
      productName: 'ABC XYZ ADSADASDA ZPAPPSPPPPPP',
      price: 1000.00,
      quantity: 20,
    ),
    Product(
      productName: 'Bộ móng tay làm nail vip pro',
      price: 987.00,
      quantity: 1000,
    ),
    Product(
      productName: 'ABC XYZ ADADADADADADADADAADA 789ADAADADADADAADADADA789',
      price: 22.00,
      quantity: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadImage();
    _find();
  }

  Future<void> _find() async {
    var ps = await StarXpand.findPrinters(
        interfaces: [StarXpandInterface.bluetooth]);
    setState(() {
      printers = ps;
    });
  }

  Future<void> _loadImage() async {
    logoBytes = await _loadImageBytes('asset/image/receipt-ocr-original.jpg');
  }

  Future<Uint8List> _loadImageBytes(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  List<String> splitStringAtIndex(String input, int index) {
    if (index < 0 || index > input.length) {
      throw RangeError('Index out of bounds');
    }

    String part1 = input.substring(0, index);
    String part2 = input.substring(index);

    return [part1, part2];
  }

  String onCaculateSpace(String left, String right) {
    int total = 48;
    int leftLength = left.length;
    int rightLength = right.length;
    int spaceLength = total - leftLength - rightLength;

    return '$left${' ' * spaceLength}$right\n\n';
  }

  _print(StarXpandPrinter printer) async {
    if (logoBytes == null) {
      return;
    }

    var doc = StarXpandDocument();
    var printDoc = StarXpandDocumentPrint();

    printDoc.style(
        internationalCharacter: StarXpandStyleInternationalCharacter.vietnam,
        characterSpace: 0.0,
        alignment: StarXpandStyleAlignment.center,
        fontType: StarXpandStyleFontType.a,
        bold: false,
        invert: false,
        underLine: false,
        magnification: StarXpandStyleMagnification(1, 1),
        lineSpace: 1.0,
        horizontalPositionTo: 0.0,
        horizontalPositionBy: 0.0,
        horizontalTabPosition: [],
        cjkCharacterPriority: []);

    printDoc.actionPrintImage(logoBytes!, 150);
    printDoc.actionPrintText("\n\n\n\n");
    printDoc.add(
      StarXpandDocumentPrint()
        ..style(bold: true)
        ..actionPrintText("Supplier name\n\n\n"),
    );
    printDoc.actionPrintText("Nguyen Trai\n\n\n"
        "Tel: (815) 376-5555\n\n\n"
        "Asia, Ho Chi Minh - Thu Jul 25 - 11:59:44 AM\n\n\n\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.add(StarXpandDocumentPrint()
      ..style(bold: true)
      ..actionPrintText("Receipt\n"));
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc
        .actionPrintText("Cashier:                              Danny Tran\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("Receipt number");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintBarcode("BB1721851796",
        symbology: StarXpandBarcodeSymbology.code128,
        barDots: 3,
        height: 30,
        printHri: true);
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText(
        "Service                                    Total\n\n\n");
    printDoc.actionPrintText(
        "------------------------------------------------\n\n\n\n");
    int totalQuantity = 20;
    for (Product product in products) {
      int spaceQuantity = 0;
      int quantityLength = product.quantity.toString().length + 1;
      int priceLength = product.price.toString().length + 1;
      spaceQuantity = totalQuantity - quantityLength - priceLength;
      String spaceString = " " * spaceQuantity;

      String right = " x" +
          product.quantity.toString() +
          spaceString +
          "\$" +
          product.price.toString();

      List<String> leftList = splitStringAtIndex(product.productName ?? '', 27);
      String left = leftList[0];
      right += leftList[1];
      printDoc.add(
        StarXpandDocumentPrint()
          ..style(
            bold: true,
            alignment: StarXpandStyleAlignment.left,
          )
          ..actionPrintText(left + right + "\n\n\n\n"),
      );
    }

    printDoc.actionPrintText(
        "------------------------------------------------\n\n");

    printDoc.add(
      StarXpandDocumentPrint()
        ..style(
            alignment: StarXpandStyleAlignment.center,
            internationalCharacter:
                StarXpandStyleInternationalCharacter.vietnam)
        ..actionPrintText("${onCaculateSpace('Subtotal', '\$1.00')}"
            "${onCaculateSpace('Loyalty Discount', '\$233.00')}"
            "${onCaculateSpace('Voucher Discount', '\$40.00')}"
            "${onCaculateSpace('Quick Discount', '\$40.00')}"
            "${onCaculateSpace('Gift Card', '\$40.00')}"
            "${onCaculateSpace('Cancellation Fee', '\$40.00')}"
            "${onCaculateSpace('Total tips', '\$40.00')}"
            "${onCaculateSpace('Tax (0.0 %)', '\$40.00')}"
            "------------------------------------------------\n\n\n"),
    );
    printDoc.add(
      StarXpandDocumentPrint()
        ..style(bold: true)
        ..actionPrintText(
            "Total Cost                                \$40.00\n\n\n"),
    );

    printDoc.actionPrintText(
        "------------------------------------------------\n\n");

    printDoc
        .actionPrintText("Cash                                      \$40.00\n\n"
            "Credit                                     \$0.00\n\n"
            "Change                                     \$0.00\n\n");
    printDoc
        .actionPrintText("------------------------------------------------\n");

    printDoc.add(
      StarXpandDocumentPrint()
        ..style(alignment: StarXpandStyleAlignment.center)
        ..actionPrintText(
          "Wifi: Exnodes\n\n"
          "Password: 123456789\n\n\n\n\n\n",
        ),
    );

    printDoc.add(
      StarXpandDocumentPrint()
        ..style(bold: true, alignment: StarXpandStyleAlignment.center)
        ..actionPrintText("Thank you !\n\n"),
    );

    printDoc.actionCut(StarXpandCutType.partial);

    doc.addPrint(printDoc);
    doc.addDrawer(StarXpandDocumentDrawer());

    StarXpand.printDocument(printer, doc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printers List'),
      ),
      body: Column(children: [
        if (printers != null)
          for (var p in printers!)
            ListTile(
              onTap: () => _print(p),
              title: Text(p.model.label),
              subtitle: Text(p.identifier),
              trailing: Text(p.interface.name),
            )
        else
          const Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}
