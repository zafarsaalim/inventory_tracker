import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanner extends StatelessWidget {
  final Function(String code) onDetect;

  const BarcodeScanner({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode")),
      body: MobileScanner(
        onDetect: (capture) {
          final barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            final code = barcode.rawValue;

            if (code != null) {
              Navigator.pop(context);
              onDetect(code);
              break;
            }
          }
        },
      ),
    );
  }
}
