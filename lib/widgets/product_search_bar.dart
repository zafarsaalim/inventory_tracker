import 'package:flutter/material.dart';
import 'base_search_field.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onScanTap;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSearchField(
      controller: controller,
      hint: "Search or scan product",
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      suffixIcon: IconButton(
        icon: const Icon(Icons.qr_code_scanner),
        onPressed: onScanTap,
      ),
    );
  }
}
