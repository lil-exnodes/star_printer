import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:starxpandprinter/starxpand.dart';

class PrintersPage extends StatefulWidget {
  const PrintersPage({Key? key}) : super(key: key);

  @override
  State<PrintersPage> createState() => _PrintersPageState();
}

class _PrintersPageState extends State<PrintersPage> {
  List<StarXpandPrinter>? printers;
  Uint8List? logoBytes;

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

  _print(StarXpandPrinter printer) async {
    if (logoBytes == null) {
      // Handle the case where the image is not loaded
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
    printDoc.add(StarXpandDocumentPrint()
      ..style(bold: true)
      ..actionPrintText(
          "Dip                                       \$40.00\n\n\n\n"));
    printDoc.actionPrintText(
        "------------------------------------------------\n\n");

    printDoc.add(
      StarXpandDocumentPrint()
        ..style(
            alignment: StarXpandStyleAlignment.left,
            internationalCharacter:
                StarXpandStyleInternationalCharacter.vietnam)
        ..actionPrintText(
            "Subtotal                                  \$40.00\n\n"
            "Loyalty Discount                          \$40.00\n\n"
            "Voucher Discount                           \$0.00\n\n"
            "Quick Discount                             \$0.00\n\n"
            "Gift Card                                  \$0.00\n\n"
            "Cancellation Fee                           \$0.00\n\n"
            "Total tips                                 \$0.00\n\n"
            "Tax (0.0 %)                                \$0.00\n\n"
            "------------------------------------------------\n\n\n"),
    );
    printDoc.add(
      StarXpandDocumentPrint()
        ..style(bold: true)
        ..actionPrintText(
            "Total  Cost                               \$40.00\n\n\n"),
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
