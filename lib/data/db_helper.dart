import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'inventory.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            barcode TEXT,
            quantity INTEGER,
            costPrice REAL,
            sellingPrice REAL,
            category TEXT,
            minStockLevel INTEGER,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertItem(Item item) async {
    final dbClient = await db;
    return dbClient.insert('items', item.toMap());
  }

  static Future<List<Item>> getItems() async {
    final dbClient = await db;
    final result = await dbClient.query('items');
    return result.map((e) => Item.fromMap(e)).toList();
  }

  static Future<int> deleteItem(int id) async {
    final dbClient = await db;
    return dbClient.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  static Future<Item?> getByBarcode(String barcode) async {
    final dbClient = await db;

    final result = await dbClient.query(
      'items',
      where: 'barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Item.fromMap(result.first);
    }
    return null;
  }
}
