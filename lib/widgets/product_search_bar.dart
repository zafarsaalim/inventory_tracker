import 'package:flutter/material.dart';
import 'base_search_field.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const ProductSearchBar({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return BaseSearchField(
      controller: controller,
      hint: "Search or scan product",
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      suffixIcon: const Icon(Icons.qr_code_scanner),
    );
  }
}
