import 'package:hive/hive.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

/// Modelo de datos para la persistencia local de transacciones.
/// Mapea la entidad [TransactionEntity] a un formato compatible con Hive.
@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  /// Identificador único de la transacción.
  @HiveField(0)
  final String id;
  
  /// ID del fondo involucrado.
  @HiveField(1)
  final String fundId;
  
  /// Nombre del fondo para facilitar la visualización sin joins.
  @HiveField(2)
  final String fundName;
  
  /// Monto operado.
  @HiveField(3)
  final double amount;
  
  /// Fecha de ejecución.
  @HiveField(4)
  final DateTime date;
  
  /// Tipo de transacción (almacenado como String).
  @HiveField(5)
  final String type;
  
  /// Método de notificación seleccionado (almacenado como String).
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

  /// Crea un [TransactionModel] desde la entidad de dominio.
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

  /// Convierte el modelo de persistencia de vuelta a la entidad de dominio.
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
