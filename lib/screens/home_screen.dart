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
    items = await DBHelper.getItems();

    setState(() {});
  }

  void handleAdd([Item? item]) {
    openAddSheet(
      context: context,
      existingItem: item,
      onSaved: loadItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(
      items: items,
      onAdd: handleAdd,
      onEdit: handleAdd,
    );
  }
}
