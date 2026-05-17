import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseCard({super.key, required this.expense, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(expense.item),
        subtitle: Text(expense.date),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "₹${expense.amount}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
