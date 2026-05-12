import 'package:hive/hive.dart';
import '../../domain/entities/fund.dart';

part 'fund_model.g.dart';

@HiveType(typeId: 0)
class FundModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double minimumAmount;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final bool isSubscribed;

  FundModel({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    required this.isSubscribed,
  });

  factory FundModel.fromEntity(Fund fund) {
    return FundModel(
      id: fund.id,
      name: fund.name,
      minimumAmount: fund.minimumAmount,
      category: fund.category.name,
      isSubscribed: fund.isSubscribed,
    );
  }

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
