class TransactionModel {
  final double amount;
  final String method;
  final DateTime date;

  TransactionModel({
    required this.amount,
    required this.method,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'method': method,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: json['amount'],
      method: json['method'],
      date: DateTime.parse(json['date']),
    );
  }
}
