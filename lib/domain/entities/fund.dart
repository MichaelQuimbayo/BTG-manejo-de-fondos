/// Representa las categorías disponibles para los fondos
enum FundCategory { fpv, fic }

/// Entidad que representa un fondo de inversión o pensión
class Fund {
  /// Identificador único del fondo
  final String id;
  
  /// Nombre descriptivo del fondo
  final String name;
  
  /// Monto mínimo requerido para la suscripción
  final double minimumAmount;
  
  /// Categoría a la que pertenece el fondo (FPV o FIC)
  final FundCategory category;
  
  /// Indica si el usuario actual está suscrito a este fondo
  final bool isSubscribed;

  const Fund({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    this.isSubscribed = false,
  });

  /// Crea una copia del fondo actual permitiendo modificar campos específicos
  /// Utilizado para mantener la inmutabilidad de la entidad
  Fund copyWith({
    String? id,
    String? name,
    double? minimumAmount,
    FundCategory? category,
    bool? isSubscribed,
  }) {
    return Fund(
      id: id ?? this.id,
      name: name ?? this.name,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      category: category ?? this.category,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}
