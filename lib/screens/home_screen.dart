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

  void openAddSheet([Item? existingItem]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddItemSheet(
          existingItem: existingItem,
          onSave: (item) async {
            final newItem = Item(
              id: existingItem?.id,
              name: item["name"],
              quantity: item["quantity"],
              category: item["category"],
              barcode: item["barcode"],
              costPrice: item["costPrice"],
              sellingPrice: item["sellingPrice"],
              createdAt: item["createdAt"],
            );

            if (existingItem != null) {
              await DBHelper.updateItem(newItem);
            } else {
              await DBHelper.insertItem(newItem);
            }

            loadItems();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: items.isEmpty
          ? EmptyInventory(onAdd: openAddSheet)
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                return ItemCard(
                  item: items[index],
                  onTap: () {
                    openAddSheet(items[index]);
                  },
                );
              },
            ),
      floatingActionButton: items.isNotEmpty
          ? FloatingActionButton(
              onPressed: openAddSheet,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
