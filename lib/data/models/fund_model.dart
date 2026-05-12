import 'package:hive/hive.dart';
import '../../domain/entities/fund.dart';

part 'fund_model.g.dart';

/// Modelo de datos para la persistencia local de un fondo utilizando Hive.
/// Actúa como un puente entre la base de datos local y la entidad de dominio [Fund].
@HiveType(typeId: 0)
class FundModel extends HiveObject {
  /// Identificador único del fondo.
  @HiveField(0)
  final String id;
  
  /// Nombre del fondo.
  @HiveField(1)
  final String name;
  
  /// Monto mínimo de suscripción.
  @HiveField(2)
  final double minimumAmount;
  
  /// Categoría del fondo almacenada como String.
  @HiveField(3)
  final String category;
  
  /// Estado de suscripción del usuario al fondo.
  @HiveField(4)
  final bool isSubscribed;

  FundModel({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    required this.isSubscribed,
  });

  /// Crea una instancia de [FundModel] a partir de una entidad de dominio [Fund].
  factory FundModel.fromEntity(Fund fund) {
    return FundModel(
      id: fund.id,
      name: fund.name,
      minimumAmount: fund.minimumAmount,
      category: fund.category.name,
      isSubscribed: fund.isSubscribed,
    );
  }

  /// Convierte este modelo en una entidad de dominio [Fund] para ser usada en la lógica de negocio.
  Fund toEntity() {
    return Fund(
      id: id,
      name: name,
      minimumAmount: minimumAmount,
      category: FundCategory.values.byName(category),
      isSubscribed: isSubscribed,
    );
  }
}
