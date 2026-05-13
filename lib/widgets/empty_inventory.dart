import 'package:flutter/material.dart';

class EmptyInventory extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyInventory({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 90, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            "No Inventory Items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "Tap below to add your first item",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text("Add Item"),
          ),
        ],
      ),
    );
  }
}
