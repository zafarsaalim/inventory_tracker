class Expense {
  int? id;
  String item;
  double amount;
  String date;

  Expense({
    this.id,
    required this.item,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'item': item, 'amount': amount, 'date': date};
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      item: map['item'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
