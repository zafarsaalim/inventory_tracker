import 'package:flutter/material.dart';
import 'barcode_scanner.dart';
import '../data/db_helper.dart';
import '../models/item.dart';

class AddItemSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Item? existingItem;

  const AddItemSheet({super.key, required this.onSave, this.existingItem});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final minStockController = TextEditingController();
  final categoryController = TextEditingController();
  final barcodeController = TextEditingController();
  final costPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  //
  Future<void> handleBarcode(String code) async {
    final existingItem = await DBHelper.getByBarcode(code);

    if (existingItem != null) {
      final updatedQty = existingItem.quantity + 1;

      await DBHelper.updateQuantity(existingItem.id!, updatedQty);
    } else {
      setState(() {
        barcodeController.text = code;
      });
    }
  }

  //
  @override
  void initState() {
    super.initState();

    if (widget.existingItem != null) {
      final item = widget.existingItem!;

      nameController.text = item.name;
      qtyController.text = item.quantity.toString();
      minStockController.text = item.minStockLevel?.toString() ?? "";
      categoryController.text = item.category;
      barcodeController.text = item.barcode ?? "";
      costPriceController.text = item.costPrice?.toString() ?? "";
      sellingPriceController.text = item.sellingPrice?.toString() ?? "";
    }
  }

  //
  @override
  void dispose() {
    nameController.dispose();
    qtyController.dispose();
    categoryController.dispose();
    barcodeController.dispose();
    costPriceController.dispose();
    sellingPriceController.dispose();
    minStockController.dispose();
    super.dispose();
  }

  //
  void submit() {
    final item = {
      "name": nameController.text.trim(),
      "quantity": int.tryParse(qtyController.text) ?? 0,
      "minStockLevel": minStockController.text.isEmpty
          ? null
          : int.tryParse(minStockController.text),

      "category": categoryController.text.trim().isEmpty
          ? "General"
          : categoryController.text.trim(),
      "barcode": barcodeController.text.trim().isEmpty
          ? null
          : barcodeController.text.trim(),
      "costPrice": costPriceController.text.isEmpty
          ? null
          : double.tryParse(costPriceController.text),
      "sellingPrice": sellingPriceController.text.isEmpty
          ? null
          : double.tryParse(sellingPriceController.text),
      "createdAt": DateTime.now().toIso8601String(),
    };

    widget.onSave(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Item",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),

            TextField(
              controller: barcodeController,
              decoration: const InputDecoration(
                labelText: "Barcode (optional)",
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan Barcode"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BarcodeScanner(
                      onDetect: (code) async {
                        await handleBarcode(code);
                      },
                    ),
                  ),
                );
              },
            ),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            TextField(
              controller: minStockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Min Stock Level",
                hintText: "Alert when stock goes below this",
              ),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),

            TextField(
              controller: costPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Cost Price"),
            ),

            TextField(
              controller: sellingPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Selling Price"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(onPressed: submit, child: const Text("Save Item")),
          ],
        ),
      ),
    );
  }
}
