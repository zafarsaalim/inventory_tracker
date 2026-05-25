import 'package:flutter/material.dart';
import '../models/item.dart';

class InventorySummary extends StatelessWidget {
  final List<Item> items;
  final VoidCallback onLowStockTap;
  const InventorySummary({
    super.key,
    required this.items,
    required this.onLowStockTap,
  });

  @override
  Widget build(BuildContext context) {
    final int totalProducts = items.length;

    final int totalUnits = items.fold(0, (sum, item) => sum + item.quantity);

    final int lowStock = items.where((item) {
      final min = item.minStockLevel ?? 5;
      return item.quantity <= min;
    }).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat("Products", totalProducts.toString()),

          _divider(),

          _buildStat("In Stock", totalUnits.toString()),

          _divider(),

          Material(
            color: Colors.transparent,
            child: InkResponse(
              onTap: onLowStockTap,
              child: _buildStat(
                "Low Stock",
                lowStock.toString(),
                valueColor: lowStock > 0 ? Colors.orange : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: Colors.grey.shade300);
  }

  Widget _buildStat(String label, String value, {Color? valueColor}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),

        const SizedBox(height: 4),

        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
