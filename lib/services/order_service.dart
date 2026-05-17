import '../models/item.dart';
import '../models/order_item.dart';
import '../data/db_helper.dart';

class OrderService {
  final List<OrderItem> basket = [];

  void addToBasket(Item item) {
    final index = basket.indexWhere((e) => e.item.id == item.id);

    if (index == -1) {
      if (item.quantity > 0) {
        basket.add(OrderItem(item: item, quantity: 1));
      }
      return;
    }

    final current = basket[index];

    if (current.quantity >= item.quantity) return;

    basket[index] = OrderItem(
      item: current.item,
      quantity: current.quantity + 1,
    );
  }

  void increaseQty(int index) {
    final item = basket[index];
    if (item.quantity < item.item.quantity) {
      item.quantity++;
    }
  }

  void decreaseQty(int index) {
    if (basket[index].quantity > 1) {
      basket[index].quantity--;
    } else {
      basket.removeAt(index);
    }
  }

  int get subtotal {
    int total = 0;
    for (var item in basket) {
      total += item.subtotal;
    }
    return total;
  }

  void clear() {
    basket.clear();
  }

  Future<void> saveOrder() async {
    if (basket.isEmpty) return;

    final orderId = await DBHelper.createOrder(subtotal);

    for (final item in basket) {
      await DBHelper.insertOrderItem(
        orderId: orderId,
        itemId: item.item.id!,
        name: item.item.name,
        price: (item.item.sellingPrice ?? 0).toInt(),
        quantity: item.quantity,
      );

      final newQty = item.item.quantity - item.quantity;
      await DBHelper.updateQuantity(item.item.id!, newQty);
    }

    basket.clear();
  }
}
