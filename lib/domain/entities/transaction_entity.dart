/// Define los tipos de transacciones disponibles en el sistema
enum TransactionType { subscription, cancellation }

/// Define los métodos de notificación que el usuario puede elegir
enum NotificationMethod { email, sms, none }

/// Entidad que representa un movimiento o transacción financiera realizada por el usuario
class TransactionEntity {
  /// Identificador único de la transacción
  final String id;
  
  /// ID del fondo asociado a la transacción
  final String fundId;
  
  /// Nombre del fondo para visualización rápida en el historial
  final String fundName;
  
  /// Monto de la transacción (positivo para suscripción y cancelación)
  final double amount;
  
  /// Fecha y hora en que se realizó el movimiento
  final DateTime date;
  
  /// Tipo de movimiento: vinculación o desvinculación
  final TransactionType type;
  
  /// Medio por el cual se notificó al usuario (si aplica)
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

  /// Crea una copia de la transacción con la posibilidad de sobreescribir campos
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
