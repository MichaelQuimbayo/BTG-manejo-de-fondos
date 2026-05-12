import 'package:hive/hive.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fundId;
  @HiveField(2)
  final String fundName;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final String type;
  @HiveField(6)
  final String notificationMethod;

  TransactionModel({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.type,
    required this.notificationMethod,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      fundId: entity.fundId,
      fundName: entity.fundName,
      amount: entity.amount,
      date: entity.date,
      type: entity.type.name,
      notificationMethod: entity.notificationMethod.name,
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      fundId: fundId,
      fundName: fundName,
      amount: amount,
      date: date,
      type: TransactionType.values.byName(type),
      notificationMethod: NotificationMethod.values.byName(notificationMethod),
    );
  }
}
