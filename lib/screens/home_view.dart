import 'package:flutter/material.dart';

import '../models/item.dart';
import '../widgets/empty_inventory.dart';
import '../widgets/item_card.dart';

class HomeView extends StatelessWidget {
  final List<Item> items;
  final Function() onAdd;
  final Function(Item) onEdit;

  const HomeView({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
      ),

      body: items.isEmpty
          ? EmptyInventory(onAdd: onAdd)
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                return ItemCard(
                  item: items[index],
                  onTap: () => onEdit(items[index]),
                );
              },
            ),

      floatingActionButton: items.isNotEmpty
          ? FloatingActionButton(
              onPressed: onAdd,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
