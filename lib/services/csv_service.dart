import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
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
}
