import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../helpers/open_add_sheet.dart';
import '../models/item.dart';
import 'home_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final data = await DBHelper.getItems();
    if (!mounted) return;
    setState(() {
      items = data;
    });
  }

  void handleAdd([Item? item]) {
    openAddSheet(context: context, existingItem: item, onSaved: loadItems);
  }

  void handleDelete(Item item) async {
    await DBHelper.deleteItem(item.id!);
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(
      items: items,
      onAdd: handleAdd,
      onDelete: handleDelete,
      onEdit: handleAdd,
      onRefresh: loadItems,
    );
  }
}
