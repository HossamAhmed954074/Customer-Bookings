import 'package:equatable/equatable.dart';

class CreditPackage extends Equatable {
  final String id;
  final String name;
  final int credits;
  final double price;
  final String? description;
  final bool isPopular;
  final double? discount;

  const CreditPackage({
    required this.id,
    required this.name,
    required this.credits,
    required this.price,
    this.description,
    this.isPopular = false,
    this.discount,
  });

  double get pricePerCredit => price / credits;

  @override
  List<Object?> get props => [
    id,
    name,
    credits,
    price,
    description,
    isPopular,
    discount,
  ];
}
