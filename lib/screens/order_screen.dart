import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/item.dart';

import '../widgets/order_empty_state.dart';
import '../widgets/order_product_tile.dart';
import '../widgets/order_search_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() =>
      _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController searchController =
      TextEditingController();

  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();

    searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> loadItems() async {
    items = await DBHelper.getItems();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query =
        searchController.text.toLowerCase();

    final filteredItems = items.where((item) {
      return item.name
          .toLowerCase()
          .contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Order"),
      ),

      body: Column(
        children: [
          OrderSearchBar(
            controller: searchController,
          ),

          Expanded(
            child: query.isEmpty
                ? const OrderEmptyState()
                : filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          "No matching products",
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            filteredItems.length,

                        itemBuilder: (_, index) {
                          final item =
                              filteredItems[index];

                          return OrderProductTile(
                            item: item,

                            onTap: () {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${item.name} selected",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
