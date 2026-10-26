import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item TEXT,
            amount REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  // Bulk insert function
  static Future<void> insertMultipleExpenses(List<Expense> expenses) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var expense in expenses) {
        await txn.insert(
          'expenses',
          expense.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // Updated to support optional date range filtering
  static Future<List<Expense>> getExpenses({String? startDate, String? endDate}) async {
    final db = await database;

    String? whereClause;
    List<dynamic>? whereArgs;

    if (startDate != null && endDate != null) {
      whereClause = 'date BETWEEN ? AND ?';
      whereArgs = [startDate, endDate];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  static Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
