import 'package:flutter/material.dart';

class TodayExpenseCard extends StatelessWidget {
  final double amount;

  const TodayExpenseCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today Expense",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "₹$amount",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
