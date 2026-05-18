import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../db/db_helper.dart';
import '../models/expense.dart';

class CSVService {
  static Future<void> importCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    File file = File(result.files.single.path!);

    String content = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter().convert(content);

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      await DBHelper.insertExpense(
        Expense(
          item: row[0].toString(),
          amount: double.parse(row[1].toString()),
          date: row[2].toString(),
        ),
      );
    }
  }

  static Future<void> exportCSV() async {
    try {
      final expenses = await DBHelper.getExpenses();

      List<List<dynamic>> rows = [
        ["Item", "Amount", "Date"], // header
      ];

      for (var e in expenses) {
        rows.add([e.item, e.amount, e.date]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      final dir = await getExternalStorageDirectory();
      // final path = "${dir!.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.csv";
      final path =
          "/storage/emulated/0/Download/expenses_${DateTime.now().millisecondsSinceEpoch}.csv";
      final file = File(path);
      await file.writeAsString(csv);

      print("Exported to: $path");
    } catch (e) {
      print("Export error: $e");
    }
  }
}
