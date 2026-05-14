import '../data/db_helper.dart';
import '../models/item.dart';

class ItemService {
  static Future<void> saveItem({
    required Map<String, dynamic> item,
    Item? existingItem,
  }) async {
    final newItem = Item(
      id: existingItem?.id,
      name: item["name"],
      quantity: item["quantity"],
      category: item["category"],
      barcode: item["barcode"],
      costPrice: item["costPrice"],
      sellingPrice: item["sellingPrice"],
      createdAt: item["createdAt"],
    );

    if (existingItem != null) {
      await DBHelper.updateItem(newItem);
    } else {
      await DBHelper.insertItem(newItem);
    }
  }
}
