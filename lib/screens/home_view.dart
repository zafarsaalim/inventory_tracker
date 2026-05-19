import 'package:flutter/material.dart';

import '../models/item.dart';
import '../widgets/empty_inventory.dart';
import '../widgets/inventory_search_bar.dart';
import '../widgets/inventory_summary.dart';
import '../widgets/item_card.dart';
import '../services/csv_service.dart';

class HomeView extends StatefulWidget {
  final List<Item> items;
  final Function() onAdd;
  final Function(Item) onEdit;
  final Future<void> Function() onReload;
  const HomeView({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onEdit,
    required this.onRefresh,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      return item.name.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              await CSVService.importItems();
              await widget.onRefresh();
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("CSV Imported")));
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await CSVService.exportItems();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("CSV Exported to Downloads")),
              );
            },
          ),
        ],
      ),

      body: widget.items.isEmpty
          ? EmptyInventory(onAdd: widget.onAdd)
          : Column(
              children: [
                InventorySearchBar(
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),

                InventorySummary(items: widget.items),

                Expanded(
                  child: filteredItems.isEmpty
                      ? const Center(child: Text("No matching items"))
                      : ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (_, index) {
                            return ItemCard(
                              item: filteredItems[index],

                              onTap: () => widget.onEdit(filteredItems[index]),
                            );
                          },
                        ),
                ),
              ],
            ),

      floatingActionButton: widget.items.isNotEmpty
          ? FloatingActionButton(
              onPressed: widget.onAdd,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
