import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/item_service.dart';
import '../widgets/add_item_sheet.dart';

void openAddSheet({
  required BuildContext context,
  Item? existingItem,
  required VoidCallback onSaved,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return AddItemSheet(
        existingItem: existingItem,

        onSave: (item) async {
          await ItemService.saveItem(item: item, existingItem: existingItem);

          onSaved();
        },
      );
    },
  );
}
