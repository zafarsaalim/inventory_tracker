import 'package:flutter/material.dart';

import '../models/order_item.dart';

class OrderBasketItem extends StatelessWidget {
  final OrderItem orderItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const OrderBasketItem({
    super.key,
    required this.orderItem,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    orderItem.item.name,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "₹${orderItem.item.sellingPrice ?? 0}",
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: onDecrease,
              icon: const Icon(Icons.remove),
            ),

            Text(
              orderItem.quantity.toString(),

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            IconButton(
              onPressed: onIncrease,
              icon: const Icon(Icons.add),
            ),

            SizedBox(
              width: 70,

              child: Text(
                "₹${orderItem.subtotal}",

                textAlign: TextAlign.end,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
