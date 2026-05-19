import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders();

    searchController.addListener(() {
      filterOrders();
    });
  }

  Future<void> loadOrders() async {
    final data = await DBHelper.getOrders();

    setState(() {
      orders = data;
      filteredOrders = data;
    });
  }

  void filterOrders() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredOrders = orders.where((order) {
        final id = order['id'].toString();
        final total = order['total'].toString();
        final date = (order['createdAt'] ?? '').toString();

        return id.contains(query) ||
            total.contains(query) ||
            date.toLowerCase().contains(query);
      }).toList();
    });
  }

  int get totalSales =>
      orders.fold(0, (sum, order) => sum + (order['total'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),

      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search orders (id, total, date)",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📊 SUMMARY SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Orders: ${orders.length}"),
                    Text("Total Sales: ₹$totalSales"),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 📦 ORDER LIST
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(child: Text("No orders found"))
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (_, index) {
                      final order = filteredOrders[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text("Order #${order['id']}"),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total: ₹${order['total']}"),
                              Text(
                                "Date: ${order['createdAt'] ?? 'N/A'}",
                              ),
                            ],
                          ),

                          trailing: const Icon(Icons.receipt_long),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
