import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final double budget;
  final double used;

  const BudgetCard({super.key, required this.budget, required this.used});

  @override
  Widget build(BuildContext context) {
    double progress = used / budget;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Budget Usage", style: TextStyle(fontSize: 18)),
                Text(
                  "₹${used.toStringAsFixed(0)} / ₹${budget.toStringAsFixed(0)}",
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              minHeight: 10,
            ),
          ],
        ),
      ),
    );
  }
}
