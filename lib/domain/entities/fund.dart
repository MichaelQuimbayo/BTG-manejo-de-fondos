enum FundCategory { fpv, fic }

class Fund {
  final String id;
  final String name;
  final double minimumAmount;
  final FundCategory category;
  final bool isSubscribed;

  const Fund({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    this.isSubscribed = false,
  });

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
