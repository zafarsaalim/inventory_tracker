import 'package:flutter/material.dart';

class InventorySearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const InventorySearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: TextField(
        onChanged: onChanged,

        decoration: InputDecoration(
          hintText: "Search inventory...",

          prefixIcon: const Icon(Icons.search),

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
