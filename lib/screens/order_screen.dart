import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/item.dart';
import '../models/order.dart';
import '../widgets/order_basket_panel_content.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/order_list_view.dart';
import '../services/order_service.dart';
import '../widgets/order_history_list.dart';
import '../widgets/barcode_scanner.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController searchController = TextEditingController();
  final OrderService service = OrderService();

  List<Item> items = [];
  List<Order> orders = [];
  bool isCreatingOrder = false;

  bool get hasSearchInput => searchController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
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

  Future<void> saveOrder() async {
    await service.saveOrder();

    setState(() {
      isCreatingOrder = false;
      searchController.clear();
    });

    await loadOrders();
  }

  List<Item> get filteredProducts {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) return [];
    return items.where((item) {
      final nameMatch = item.name.toLowerCase().contains(query);
      final barcodeMatch = item.barcode?.toLowerCase().contains(query) ?? false;
      return nameMatch || barcodeMatch;
    }).toList();
  }

  int get subtotal => service.subtotal;

  Widget _buildCreateOrderView() {
    return Column(
      children: [
        ProductSearchBar(
          controller: searchController,
          onScanTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BarcodeScanner(
                  onDetect: (code) {
                    setState(() {
                      searchController.text = code;
                    });
                  },
                ),
              ),
            );
          },
        ),

        if (hasSearchInput) _buildSearchResults(),

        if (service.basket.isNotEmpty)
          OrderBasketPanel(
            basket: service.basket,
            subtotal: subtotal,
            increaseQty: (index) {
              setState(() {
                service.increaseQty(index);
              });
            },
            decreaseQty: (index) {
              setState(() {
                service.decreaseQty(index);
              });
            },
            onSave: saveOrder,
          ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: filteredProducts.map((item) {
        return ListTile(
          title: Text(item.name),
          onTap: () {
            setState(() {
              service.addToBasket(item);
              searchController.clear();
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isCreatingOrder = !isCreatingOrder;
            if (!isCreatingOrder) {
              service.clear();
              searchController.clear();
            }
          });
        },
        child: Icon(isCreatingOrder ? Icons.close : Icons.add),
      ),
      body: isCreatingOrder
          ? _buildCreateOrderView()
          : OrderHistoryList(orders: orders),
    );
  }
}
