// widgets/order_list_view.dart
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderListView extends StatelessWidget {
  final List<Order> orders;

  const OrderListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders recorded yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: ListTile(
            title: Text("Order #${order.id ?? index + 1}"),
            subtitle: Text("Total: ₹${order.total}"),
          ),
        );
      },
    );
  }
}
