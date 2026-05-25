import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../data/db_helper.dart';

class OrderHistoryList extends StatefulWidget {
  final List<Order> orders;

  const OrderHistoryList({super.key, required this.orders});

  @override
  State<OrderHistoryList> createState() => _OrderHistoryListState();
}

class _OrderHistoryListState extends State<OrderHistoryList> {
  final TextEditingController searchController = TextEditingController();

  int get totalSales => widget.orders.fold(0, (sum, o) => sum + o.total);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM, hh:mm a').format(date);
  }

  /// 📊 % CHANGE (last vs previous)
  double get salesChangePercent {
    if (widget.orders.length < 2) return 0;

    final sorted = [...widget.orders]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final latest = sorted[0].total;
    final previous = sorted[1].total;

    if (previous == 0) return 0;

    return ((latest - previous) / previous) * 100;
  }

  /// 📊 ORDERS CHANGE %
  double get ordersChangePercent {
    if (widget.orders.length < 2) return 0;

    return ((1) / (widget.orders.length - 1)) * 100;
  }

  void showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order #${order.id}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("Total: ₹${order.total}"),
              Text("Date: ${formatDate(order.createdAt)}"),
            ],
          ),
        );
      },
    );
  }

  /// ❌ CONFIRM DELETE (simple)
  Future<void> deleteOrder(Order order) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Order"),
        content: Text("Delete Order #${order.id}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await DBHelper.deleteOrder(order.id);

    setState(() {
      widget.orders.removeWhere((o) => o.id == order.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();

    final displayOrders = query.isEmpty
        ? widget.orders
        : widget.orders.where((order) {
            final id = order.id.toString();
            final total = order.total.toString();
            final date = order.createdAt.toString().toLowerCase();

            return id.contains(query) ||
                total.contains(query) ||
                date.contains(query);
          }).toList();

    displayOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final salesChange = salesChangePercent;
    final ordersChange = ordersChangePercent;

    return Column(
      children: [
        /// 🔍 SEARCH
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Search orders",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        /// 📊 SUMMARY WITH %
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Orders: ${widget.orders.length}"),
                      Text("₹$totalSales"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Orders Δ: ${ordersChange.toStringAsFixed(1)}%",
                        style: TextStyle(
                          color: ordersChange >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        "Sales Δ: ${salesChange.toStringAsFixed(1)}%",
                        style: TextStyle(
                          color: salesChange >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        /// 📦 LIST
        Expanded(
          child: displayOrders.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("No orders found"),
                  ],
                )
              : ListView.builder(
                  itemCount: displayOrders.length,
                  itemBuilder: (_, index) {
                    final order = displayOrders[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        onTap: () => showOrderDetails(order),
                        onLongPress: () => deleteOrder(order),

                        leading: const CircleAvatar(
                          child: Icon(Icons.receipt_long),
                        ),

                        title: Text("Order #${order.id}"),

                        subtitle: Text(formatDate(order.createdAt)),

                        trailing: Text(
                          "₹${order.total}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
