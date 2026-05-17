class Order {
  final int id;
  final int total;
  final DateTime createdAt;

  Order({required this.id, required this.total, required this.createdAt});

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      total: map['total'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
