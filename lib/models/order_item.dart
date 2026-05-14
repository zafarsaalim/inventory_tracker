import 'item.dart';

class OrderItem {
  final Item item;
  int quantity;

  OrderItem({
    required this.item,
    this.quantity = 1,
  });

  int get subtotal {
    final price =
        item.sellingPrice?.toInt() ?? 0;

    return price * quantity;
  }
}
