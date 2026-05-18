import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../data/db_helper.dart';
import '../models/item.dart';

class CSVService {
  /// EXPORT CSV
  static Future<void> exportItems() async {
    final items = await DBHelper.getItems();

    List<List<dynamic>> rows = [
      [
        "name",
        "barcode",
        "quantity",
        "costPrice",
        "sellingPrice",
        "category",
        "minStockLevel",
        "createdAt",
      ],
    ];

    for (var item in items) {
      rows.add([
        item.name,
        item.barcode ?? "",
        item.quantity,
        item.costPrice ?? "",
        item.sellingPrice ?? "",
        item.category,
        item.minStockLevel ?? "",
        item.createdAt,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final now = DateTime.now();

    final fileName =
        "inventory_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}.csv";

    final file = File("/storage/emulated/0/Download/$fileName");
    await file.writeAsString(csv);
  }

  /// IMPORT CSV
  static Future<void> importItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    final file = File(result.files.single.path!);
    final csvString = await file.readAsString();

    List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      final item = Item(
        name: row[0].toString(),
        barcode: row[1].toString().isEmpty ? null : row[1].toString(),
        quantity: int.tryParse(row[2].toString()) ?? 0,
        costPrice: row[3].toString().isEmpty
            ? null
            : double.tryParse(row[3].toString()),
        sellingPrice: row[4].toString().isEmpty
            ? null
            : double.tryParse(row[4].toString()),
        category: row[5].toString(),
        minStockLevel: row[6].toString().isEmpty
            ? null
            : int.tryParse(row[6].toString()),
        createdAt: row[7].toString().isEmpty
            ? DateTime.now().toIso8601String()
            : row[7].toString(),
      );

      await DBHelper.insertItem(item);
    }
  }
}
