import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/expense.dart';
import '../services/csv_service.dart';
import '../widgets/budget_card.dart';
import '../widgets/expense_card.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  List<Expense> filtered = [];

  final searchController = TextEditingController();
  double budget = 5000;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    expenses = await DBHelper.getExpenses();
    filtered = expenses;
    setState(() {});
  }

  void search(String value) {
    filtered = expenses.where((e) {
      return e.item.toLowerCase().contains(value.toLowerCase());
    }).toList();

    setState(() {});
  }

  double get totalExpense {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: () async {
              await CSVService.importCSV();
              loadExpenses();
            },
            icon: const Icon(Icons.upload_file),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search expenses",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),
            SummaryCard(total: totalExpense),

            BudgetCard(budget: budget, used: totalExpense),

            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        "No records.\nAdd expenses.",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final expense = filtered[index];

                        return ExpenseCard(
                          expense: expense,
                          onDelete: () async {
                            await DBHelper.deleteExpense(expense.id!);
                            loadExpenses();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );

          if (result == true) {
            loadExpenses();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
