import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    String? startStr = startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : null;
    String? endStr = endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null;

    expenses = await DBHelper.getExpenses(startDate: startStr, endDate: endStr);
    search(searchController.text);
  }

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      loadExpenses();
    }
  }

  void _clearDateFilter() {
    setState(() {
      startDate = null;
      endDate = null;
    });
    loadExpenses();
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
          IconButton(
            onPressed: () async {
              await CSVService.exportCSV();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("CSV Exported Successfully")),
              );
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search Bar
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
            const SizedBox(height: 8),

            // Date Range Filter Bar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDateRange,
                    icon: const Icon(Icons.date_range, size: 18),
                    label: Text(
                      startDate == null || endDate == null
                          ? "Filter by Date Range"
                          : "${DateFormat('dd MMM').format(startDate!)} - ${DateFormat('dd MMM').format(endDate!)}",
                    ),
                  ),
                ),
                if (startDate != null && endDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: _clearDateFilter,
                    tooltip: "Clear Date Filter",
                  ),
              ],
            ),

            const SizedBox(height: 12),
            SummaryCard(total: totalExpense),

            BudgetCard(budget: budget, used: totalExpense),

            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        "No records found.\nAdd expenses or change filter.",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final expense = filtered[index];

                        // Subtle alternate row shading
                        final bool isEven = index % 2 == 0;
                        final Color? rowColor = isEven
                            ? Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3)
                            : null;

                        return Container(
                          color: rowColor,
                          child: ExpenseCard(
                            expense: expense,
                            onDelete: () async {
                              await DBHelper.deleteExpense(expense.id!);
                              loadExpenses();
                            },
                          ),
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
