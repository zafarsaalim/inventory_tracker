import 'package:flutter/material.dart';
import 'base_search_field.dart';

class InventorySearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const InventorySearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BaseSearchField(
      hint: "Search inventory...",
      onChanged: onChanged,
    );
  }
}
