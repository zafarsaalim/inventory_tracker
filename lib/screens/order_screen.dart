import 'package:flutter/material.dart';

import '../data/db_helper.dart';

import '../models/item.dart';
import '../models/order_item.dart';

import '../widgets/order_basket_item.dart';
import '../widgets/order_empty_state.dart';
import '../widgets/order_product_tile.dart';
import '../widgets/order_search_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Item> items = [];

  List<OrderItem> basket = [];

  @override
  void initState() {
    super.initState();

    loadItems();

    searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> loadItems() async {
    items = await DBHelper.getItems();

    setState(() {});
  }

  void addToBasket(Item item) {
    final existingIndex = basket.indexWhere(
      (orderItem) => orderItem.item.id == item.id,
    );

    setState(() {
      if (existingIndex >= 0) {
        final currentQty = basket[existingIndex].quantity;

        if (currentQty < item.quantity) {
          basket[existingIndex].quantity++;
        }
      } else {
        if (item.quantity > 0) {
          basket.add(OrderItem(item: item, quantity: 1));
        }
      }
    });
  }

  void increaseQty(int index) {
    setState(() {
      final item = basket[index];

      if (item.quantity < item.item.quantity) {
        item.quantity++;
      }
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (basket[index].quantity > 1) {
        basket[index].quantity--;
      } else {
        basket.removeAt(index);
      }
    });
  }

  int get subtotal {
    int total = 0;

    for (var item in basket) {
      total += item.subtotal;
    }

    return total;
  }

  Future<void> saveOrder() async {
    if (basket.isEmpty) return;

    final orderId = await DBHelper.createOrder(subtotal);

    for (final item in basket) {
      await DBHelper.insertOrderItem(
        orderId: orderId,
        itemId: item.item.id!,
        name: item.item.name,
        price: (item.item.sellingPrice ?? 0).toInt(),
        quantity: item.quantity,
      );

      final newQty = item.item.quantity - item.quantity;

      await DBHelper.updateQuantity(item.item.id!, newQty);
    }

    setState(() {
      basket.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();

    final filteredItems = items.where((item) {
      return item.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Record Order")),

      body: Column(
        children: [
          OrderSearchBar(controller: searchController),

          if (basket.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(top: 4, bottom: 4),

              child: Column(
                children: [
                  ...List.generate(basket.length, (index) {
                    return OrderBasketItem(
                      orderItem: basket[index],

                      onIncrease: () => increaseQty(index),

                      onDecrease: () => decreaseQty(index),
                    );
                  }),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Subtotal",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "₹$subtotal",

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: basket.isEmpty ? null : saveOrder,
                          child: const Text("Save Order"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: filteredItems.isEmpty
                ? const OrderEmptyState()
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (_, index) {
                      final item = filteredItems[index];

                      return OrderProductTile(
                        item: item,
                        onTap: () {
                          addToBasket(item);
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
