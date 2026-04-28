import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  void refreshItems() async {
    final data = await DatabaseHelper().getItems();
    setState(() {
      items = data;
    });
  }

  void deleteItem(int id) async {
    await DatabaseHelper().deleteItem(id);
    refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventory Tracker")),
      body: items.isEmpty
          ? Center(child: Text("No items yet"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Quantity: ${item.quantity}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteItem(item.id!),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddItemScreen(item: item),
                      ),
                    );
                    refreshItems();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddItemScreen()),
          );
          refreshItems();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
