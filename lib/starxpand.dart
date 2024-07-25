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

    // In ảnh logo đã được preload
    printDoc.actionPrintImage(logoBytes!, 200);
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("\n");
    printDoc.actionPrintText("Star Clothing Boutique\n"
        "123 Star Road\n"
        "City, State 12345\n");

    printDoc.style(alignment: StarXpandStyleAlignment.center);
    printDoc.actionPrintText("Date:MM/DD/YYYY    Time:HH:MM PM\n"
        "--------------------------------\n");

    printDoc.add(StarXpandDocumentPrint()
      ..style(bold: true)
      ..actionPrintText("SALE\n"));

    printDoc.actionPrintText("SKU         Description    Total\n"
        "--------------------------------\n");
    printDoc.style(
        alignment: StarXpandStyleAlignment.center,
        internationalCharacter: StarXpandStyleInternationalCharacter.vietnam);
    printDoc
        .actionPrintText("300678566   BLACK DENIM BLACK DENIMBLACK 1110.9\$\n"
            "300678566   Việt DENIM BLACK DENI BLACK  1110.9\$\n"
            "300651148   BLUE DENIM White                 .9\$\n"
            "300642980   STRIPED DRESS                  49.9\$\n"
            "300638471   BLACK BOOTS                    35.9\$\n"
            "300638471  Đinh Ngọc Đô BLACK BOOTS                    35.9\$\n"
            "Subtotal                                  156.9\$\n"
            "Tax                                         0.0\$\n"
            "------------------------------------------------\n");
    printDoc
        .actionPrintText("300678566   BLACK DENIM BLACK DENIMBLACK 1110.9\$\n"
            "300678566   Việt DENIM BLACK DENI BLACK  1110.9\$\n"
            "300651148   BLUE DENIM White                 .9\$\n"
            "300642980   STRIPED DRESS                  49.9\$\n"
            "300638471   BLACK BOOTS                    35.9\$\n"
            "300638471  Đinh Ngọc Đô BLACK BOOTS                    35.9\$\n"
            "Subtotal                                  156.9\$\n"
            "Tax                                         0.0\$\n"
            "------------------------------------------------\n");
    printDoc
        .actionPrintText("300678566   BLACK DENIM BLACK DENIMBLACK 1110.9\$\n"
            "300678566   Việt DENIM BLACK DENI BLACK  1110.9\$\n"
            "300651148   BLUE DENIM White                 .9\$\n"
            "300642980   STRIPED DRESS                  49.9\$\n"
            "300638471   BLACK BOOTS                    35.9\$\n"
            "300638471  Đinh Ngọc Đô BLACK BOOTS                    35.9\$\n"
            "Subtotal                                  156.9\$\n"
            "Tax                                         0.0\$\n"
            "------------------------------------------------\n");
    printDoc
        .actionPrintText("300678566   BLACK DENIM BLACK DENIMBLACK 1110.9\$\n"
            "300678566   Việt DENIM BLACK DENI BLACK  1110.9\$\n"
            "300651148   BLUE DENIM White                 .9\$\n"
            "300642980   STRIPED DRESS                  49.9\$\n"
            "300638471   BLACK BOOTS                    35.9\$\n"
            "300638471  Đinh Ngọc Đô BLACK BOOTS                    35.9\$\n"
            "Subtotal                                  156.9\$\n"
            "Tax                                         0.0\$\n"
            "------------------------------------------------\n");
    printDoc
        .actionPrintText("300678566   BLACK DENIM BLACK DENIMBLACK 1110.9\$\n"
            "300678566   Việt DENIM BLACK DENI BLACK  1110.9\$\n"
            "300651148   BLUE DENIM White                 .9\$\n"
            "300642980   STRIPED DRESS                  49.9\$\n"
            "300638471   BLACK BOOTS                    35.9\$\n"
            "300638471  Đinh Ngọc Đô BLACK BOOTS                    35.9\$\n"
            "Subtotal                                  156.9\$\n"
            "Tax                                         0.0\$\n"
            "------------------------------------------------\n");
    printDoc.actionPrintText("Total     ");

    printDoc.add(StarXpandDocumentPrint()
      ..style(magnification: StarXpandStyleMagnification(1, 1))
      ..actionPrintText("   \$156.95\n"));

    printDoc
        .actionPrintText("------------------------------------------------\n"
            "Charge\n"
            "156.95\n"
            "Visa XXXX-XXXX-XXXX-0123\n");

    printDoc.add(StarXpandDocumentPrint()
      ..style(invert: true)
      ..actionPrintText("Refunds and Exchanges\n"));

    printDoc.actionPrintText("Within ");

    printDoc.add(StarXpandDocumentPrint()
      ..style(underLine: true)
      ..actionPrintText("30 days"));

    printDoc.actionPrintText(" with receipt\n");
    printDoc.actionPrintText("And tags attached\n\n");

    printDoc.style(
        alignment: StarXpandStyleAlignment.center,
        internationalCharacter: StarXpandStyleInternationalCharacter.vietnam);

    printDoc.actionPrintBarcode("0123456",
        symbology: StarXpandBarcodeSymbology.jan8,
        barDots: 3,
        height: 5,
        printHri: true);

    printDoc.actionFeedLine(1);

    printDoc.actionPrintQRCode("Hello, World\n",
        level: StarXpandQRCodeLevel.l, cellSize: 8);

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
