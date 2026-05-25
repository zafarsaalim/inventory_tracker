import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OrderEmptyState extends StatelessWidget {
  const OrderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: const [
          Icon(
            Icons.receipt_long_outlined,
            size: 70,
            color: AppColors.textMuted,
          ),

          SizedBox(height: 16),

          Text(
            "No products added yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 8),

          Text(
            "Search or scan a product to start",
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
