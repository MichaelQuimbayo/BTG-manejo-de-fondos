enum TransactionType { subscription, cancellation }
enum NotificationMethod { email, sms, none }

class TransactionEntity {
  final String id;
  final String fundId;
  final String fundName;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final NotificationMethod notificationMethod;

  const TransactionEntity({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.type,
    this.notificationMethod = NotificationMethod.none,
  });

  TransactionEntity copyWith({
    String? id,
    String? fundId,
    String? fundName,
    double? amount,
    DateTime? date,
    TransactionType? type,
    NotificationMethod? notificationMethod,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      fundId: fundId ?? this.fundId,
      fundName: fundName ?? this.fundName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      notificationMethod: notificationMethod ?? this.notificationMethod,
    );
  }
}
