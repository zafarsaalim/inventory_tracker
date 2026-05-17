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

  void saveExpense() async {
    if (itemController.text.isEmpty || amountController.text.isEmpty) {
      return;
    }

    await DBHelper.insertExpense(
      Expense(
        item: itemController.text,
        amount: double.parse(amountController.text),
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: itemController,
              decoration: const InputDecoration(labelText: "Item"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                ),
                TextButton(
                  onPressed: pickDate,
                  child: const Text("Select Date"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: saveExpense, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
