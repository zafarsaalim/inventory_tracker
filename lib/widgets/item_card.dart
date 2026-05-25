import 'package:flutter/material.dart';
import '../models/item.dart';
import '../theme/app_colors.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;
  final Function(Item)? onDelete;
  const ItemCard({super.key, required this.item, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(item.name),
        subtitle: Text("Qty: ${item.quantity} | ${item.category}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.danger),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Item"),
                      content: const Text(
                        "Are you sure you want to delete this item?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog first
                            if (onDelete != null) {
                              onDelete!(item);
                            }
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: AppColors.danger),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
