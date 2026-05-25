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

        await db.execute('''
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      total INTEGER,
      createdAt TEXT
    )
  ''');

        await db.execute('''
    CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,
      itemId INTEGER,
      name TEXT,
      price INTEGER,
      quantity INTEGER
    )
  ''');
      },
    );
  }

  static Future<int> insertItem(Item item) async {
    final dbClient = await db;
    return dbClient.insert('items', item.toMap());
  }

  static Future<int> updateItem(Item item) async {
    final dbClient = await db;

    return await dbClient.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
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

  static Future<int> updateQuantity(int id, int quantity) async {
    final dbClient = await db;

    return dbClient.update(
      'items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> createOrder(int total) async {
    final dbClient = await db;

    return dbClient.insert('orders', {
      'total': total,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> insertOrderItem({
    required int orderId,
    required int itemId,
    required String name,
    required int price,
    required int quantity,
  }) async {
    final dbClient = await db;

    await dbClient.insert('order_items', {
      'orderId': orderId,
      'itemId': itemId,
      'name': name,
      'price': price,
      'quantity': quantity,
    });
  }

  static Future<int> deleteOrder(int id) async {
    final dbClient = await db;

    // optional: delete related order_items first (important cleanup)
    await dbClient.delete('order_items', where: 'orderId = ?', whereArgs: [id]);

    return dbClient.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final dbClient = await db;

    return dbClient.query('orders', orderBy: 'id DESC');
  }
}
