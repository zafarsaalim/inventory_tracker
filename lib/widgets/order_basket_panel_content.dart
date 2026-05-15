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

    return Positioned(
      bottom: 80,
      left: 12,
      right: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(basket.length, (index) {
                final item = basket[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.item.name)),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => decreaseQty(index),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => increaseQty(index),
                    ),
                  ],
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
                  ElevatedButton(
                    onPressed: onSave,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
