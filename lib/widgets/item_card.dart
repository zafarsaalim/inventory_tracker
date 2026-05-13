import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text("Qty: ${item.quantity} | ${item.category}"),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
