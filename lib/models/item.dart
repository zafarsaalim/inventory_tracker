class Item {
  final int? id;
  final String name;
  final String? barcode;
  final int quantity;
  final double? costPrice;
  final double? sellingPrice;
  final String category;
  final int? minStockLevel;
  final String createdAt;

  Item({
    this.id,
    required this.name,
    this.barcode,
    required this.quantity,
    this.costPrice,
    this.sellingPrice,
    required this.category,
    this.minStockLevel,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'quantity': quantity,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'minStockLevel': minStockLevel,
      'createdAt': createdAt,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      quantity: map['quantity'],
      costPrice: map['costPrice'],
      sellingPrice: map['sellingPrice'],
      category: map['category'],
      minStockLevel: map['minStockLevel'],
      createdAt: map['createdAt'],
    );
  }
}
