import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final itemController = TextEditingController();
  final amountController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final List<Expense> _queue = [];

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addToQueue() {
    if (itemController.text.trim().isEmpty || amountController.text.trim().isEmpty) {
      return;
    }
    final double? amount = double.tryParse(amountController.text);
    if (amount == null) return;

    setState(() {
      _queue.add(
        Expense(
          item: itemController.text.trim(),
          amount: amount,
          date: DateFormat('yyyy-MM-dd').format(selectedDate),
        ),
      );
      itemController.clear();
      amountController.clear();
    });
  }

  void _removeFromQueue(int index) {
    setState(() {
      _queue.removeAt(index);
    });
  }

  Future<void> _saveExpenses() async {
    // If user typed something in the fields but didn't click "Add", include it automatically
    if (itemController.text.trim().isNotEmpty && amountController.text.trim().isNotEmpty) {
      final double? amount = double.tryParse(amountController.text);
      if (amount != null) {
        _queue.add(
          Expense(
            item: itemController.text.trim(),
            amount: amount,
            date: DateFormat('yyyy-MM-dd').format(selectedDate),
          ),
        );
      }
    }

    if (_queue.isEmpty) return;

    await DBHelper.insertMultipleExpenses(_queue);
    Navigator.pop(context, true);
  }

  double get _totalAmount {
    double currentInput = double.tryParse(amountController.text) ?? 0.0;
    double queueSum = _queue.fold(0.0, (sum, item) => sum + item.amount);
    return queueSum + currentInput;
  }

  @override
  Widget build(BuildContext context) {
    bool hasActiveInput = itemController.text.trim().isNotEmpty && amountController.text.trim().isNotEmpty;
    int totalItemsCount = _queue.length + (hasActiveInput ? 1 : 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Common Date Row
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: pickDate,
                  child: const Text("Change Date"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Item Input
            TextField(
              controller: itemController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: "Item",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Amount Input & Add Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _addToQueue,
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Queue Header & Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Queued Items (${_queue.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Total: ₹$_totalAmount",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Queue List Preview
            Expanded(
              child: _queue.isEmpty
                  ? const Center(
                      child: Text(
                        "Type items and click 'Add' to batch, \nor just fill fields and click Save for single item.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _queue.length,
                      itemBuilder: (context, index) {
                        final expense = _queue[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(expense.item),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "₹${expense.amount.toStringAsFixed(2)}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeFromQueue(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (_queue.isEmpty && !hasActiveInput) ? null : _saveExpenses,
                child: Text(
                  totalItemsCount > 1 ? "Save All ($totalItemsCount items)" : "Save",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
