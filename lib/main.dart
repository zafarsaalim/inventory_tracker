import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' aa p;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class Item {
  final int? id;
  final String name;
  final int quantity;

  Item({this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database? db;
  List<Item> items = [];

  final nameController = TextEditingController();
  final qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    final path = p.join(await getDatabasesPath(), 'inventory.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER
          )
        ''');
      },
    );

    loadItems();
  }

  Future<void> loadItems() async {
    final data = await db!.query('items');
    setState(() {
      items = data.map((e) => Item.fromMap(e)).toList();
    });
  }

  Future<void> addItem() async {
    final name = nameController.text.trim();
    final qty = int.tryParse(qtyController.text) ?? 0;

    if (name.isEmpty) return;

    await db!.insert('items', {
      'name': name,
      'quantity': qty,
    });

    nameController.clear();
    qtyController.clear();

    loadItems();
  }

  Future<void> deleteItem(int id) async {
    await db!.delete('items', where: 'id = ?', whereArgs: [id]);
    loadItems();
  }

  Future<void> updateItem(Item item) async {
    await db!.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    loadItems();
  }

  void showEditDialog(Item item) {
    final editName = TextEditingController(text: item.name);
    final editQty = TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: editName),
            TextField(
              controller: editQty,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final updated = Item(
                id: item.id,
                name: editName.text,
                quantity: int.tryParse(editQty.text) ?? 0,
              );
              updateItem(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory SQLite MVP')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addItem,
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Qty: ${item.quantity}'),
                  onTap: () => showEditDialog(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(item.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
