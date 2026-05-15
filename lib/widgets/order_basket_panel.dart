import 'package:flutter/material.dart';
import '../models/order_item.dart';
import '../widgets/order_basket_item.dart';

class OrderBasketPanel extends StatelessWidget {
  final List<OrderItem> basket;
  final int subtotal;
  final VoidCallback onSave;
  final Function(int) onIncrease;
  final Function(int) onDecrease;

  const OrderBasketPanel({
    super.key,
    required this.basket,
    required this.subtotal,
    required this.onSave,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    if (basket.isEmpty) return const SizedBox();

    return Column(
      children: [
        ...List.generate(basket.length, (index) {
          return OrderBasketItem(
            orderItem: basket[index],
            onIncrease: () => onIncrease(index),
            onDecrease: () => onDecrease(index),
          );
        }),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Subtotal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹$subtotal",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: onSave,
                child: const Text("Save Order"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
