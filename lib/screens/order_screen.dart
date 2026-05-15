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
  @override
  void initState() {
    super.initState();
    loadItems();
    loadOrders();
    searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
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
            isCreatingOrder = true;
            searchController.clear();
          });
        },
        child: Icon(isCreatingOrder ? Icons.shopping_cart : Icons.add),
      ),
      body: Column(
        children: [
          Column(
            children: [
              OrderSearchBar(controller: searchController),
              if (isCreatingOrder)
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
              Expanded(child: OrderListView(orders: orders)),
            ],
          ),
        ],
      ),
    );
  }
}
