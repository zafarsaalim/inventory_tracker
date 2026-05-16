// widgets/order_basket_panel_content.dart
import 'package:flutter/material.dart';
import '../models/order_item.dart';

class OrderBasketPanel extends StatelessWidget {
  final List<OrderItem> basket;
  final int subtotal;
  final void Function(int index) increaseQty;
  final void Function(int index) decreaseQty;
  final VoidCallback onSave;

  const OrderBasketPanel({
    super.key,
    required this.basket,
    required this.subtotal,
    required this.increaseQty,
    required this.decreaseQty,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    if (basket.isEmpty) return const SizedBox.shrink();

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(basket.length, (index) {
              final item = basket[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.item.name),
                          Text(
                            '₹${item.item.sellingPrice ?? 0} x ${item.quantity}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => decreaseQty(index),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => increaseQty(index),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '₹${item.subtotal}',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₹$subtotal",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(onPressed: onSave, child: const Text("Save")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
