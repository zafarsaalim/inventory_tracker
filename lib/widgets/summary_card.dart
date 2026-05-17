import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double total;

  const SummaryCard({super.key, required this.total});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Expenses", style: TextStyle(fontSize: 18)),
            Text(
              "₹${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
