import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderHistoryList extends StatefulWidget {
  final List<Order> orders;

  const OrderHistoryList({super.key, required this.orders});

  @override
  State<OrderHistoryList> createState() => _OrderHistoryListState();
}

class _OrderHistoryListState extends State<OrderHistoryList> {
  late List<Order> filteredOrders;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOrders = widget.orders;
    searchController.addListener(filterOrders);
  }

  void filterOrders() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredOrders = widget.orders.where((order) {
        final id = order.id.toString();
        final total = order.total.toString();
        final date = order.createdAt.toLowerCase();

        return id.contains(query) ||
            total.contains(query) ||
            date.contains(query);
      }).toList();
    });
  }

  int get totalSales => widget.orders.fold(0, (sum, o) => sum + o.total);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// SEARCH
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchController,
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

        /// SUMMARY
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Orders: ${widget.orders.length}"),
                  Text("₹$totalSales"),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        /// LIST
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
                        title: Text("Order #${order.id}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("₹${order.total}"),
                            Text(order.createdAt),
                          ],
                        ),
                        trailing: const Icon(Icons.receipt_long),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
