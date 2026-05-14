import 'package:flutter/material.dart';

import '../models/item.dart';

class OrderProductTile extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const OrderProductTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),

      child: ListTile(
        onTap: onTap,

        title: Text(item.name),

        subtitle: Text(
          "${item.category} • Qty: ${item.quantity}",
        ),

        trailing: const Icon(Icons.add),
      ),
    );
  }
}
