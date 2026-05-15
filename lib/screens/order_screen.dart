import 'package:flutter/material.dart';

import '../data/db_helper.dart';

import '../models/item.dart';
import '../models/order_item.dart';
import '../models/order.dart';
import '../widgets/order_basket_item.dart';
import '../widgets/order_empty_state.dart';
import '../widgets/order_product_tile.dart';
import '../widgets/order_search_bar.dart';
import '../widgets/order_basket_panel_content.dart';
import '../widgets/order_list_view.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Item> items = [];
  List<OrderItem> basket = [];
  List<Order> orders = [];
  bool isCreatingOrder = false;
  bool get hasSearchInput {
    return searchController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    loadItems();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final dbOrders = await DBHelper.getOrders();
    setState(() {
      orders = dbOrders.map((o) => Order.fromMap(o)).toList();
    });
  }

  Future<void> loadItems() async {
    items = await DBHelper.getItems();
    setState(() {});
  }

  void addToBasket(Item item) {
    setState(() {
      final index = basket.indexWhere((e) => e.item.id == item.id);

      if (index == -1) {
        // first time add
        if (item.quantity > 0) {
          basket.add(OrderItem(item: item, quantity: 1));
        }
        return;
      }

      final current = basket[index];

      // HARD LIMIT CHECK (always deterministic)
      if (current.quantity >= item.quantity) {
        return;
      }

      basket[index] = OrderItem(
        item: current.item,
        quantity: current.quantity + 1,
      );
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

  List<Item> get filteredProducts {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) return [];

    return items.where((item) {
      return item.name.toLowerCase().contains(query);
    }).toList();
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
      isCreatingOrder = false;
      searchController.clear();
    });
    await loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isCreatingOrder = !isCreatingOrder;

            // reset only when leaving create mode
            if (!isCreatingOrder) {
              basket.clear();
              searchController.clear();
            }
          });
        },
        child: Icon(isCreatingOrder ? Icons.close : Icons.add),
      ),
      body: isCreatingOrder
          ? Column(
              children: [
                OrderSearchBar(controller: searchController),
                if (hasSearchInput)
                  Column(
                    children: filteredProducts
                        .map(
                          (item) => ListTile(
                            title: Text(item.name),
                            onTap: () {
                              addToBasket(item);
                              searchController.clear();
                              setState(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),

                if (basket.isNotEmpty)
                  OrderBasketPanel(
                    basket: basket,
                    subtotal: subtotal,
                    increaseQty: increaseQty,
                    decreaseQty: decreaseQty,
                    onSave: saveOrder,
                  ),
              ],
            )
          : OrderListView(orders: orders),
    );
  }
}
