import 'package:flutter/material.dart';

class OrderSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const OrderSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          hintText: "Search or scan product",

          prefixIcon: const Icon(Icons.search),

          suffixIcon: const Icon(Icons.qr_code_scanner),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
