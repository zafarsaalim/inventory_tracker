import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/item.dart';
import '../widgets/empty_inventory.dart';
import '../widgets/item_card.dart';
import '../widgets/add_item_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    items = await DBHelper.getItems();
    setState(() {});
  }

  void showAddSheet() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    final categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final item = Item(
                    name: nameController.text,
                    quantity: int.tryParse(qtyController.text) ?? 0,
                    category: categoryController.text,
                    createdAt: DateTime.now().toIso8601String(),
                  );

                  await DBHelper.insertItem(item);
                  Navigator.pop(context);
                  loadItems();
                },
                child: const Text("Save Item"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: items.isEmpty
          ? EmptyInventory(onAdd: showAddSheet)
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                return ItemCard(item: items[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return AddItemSheet(
                onSave: (item) async {
                  await DBHelper.insertItem(
                    Item(
                      name: item["name"],
                      quantity: item["quantity"],
                      category: item["category"],
                      barcode: item["barcode"],
                      costPrice: item["costPrice"],
                      sellingPrice: item["sellingPrice"],
                      createdAt: item["createdAt"],
                    ),
                  );

                  loadItems();
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
