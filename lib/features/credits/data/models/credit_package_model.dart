import 'package:customer_booking/features/credits/domain/entities/credit_package.dart';

class CreditPackageModel {
  final String id;
  final String name;
  final int credits;
  final double price;
  final String? description;
  final bool isPopular;
  final double? discount;

  CreditPackageModel({
    required this.id,
    required this.name,
    required this.credits,
    required this.price,
    this.description,
    this.isPopular = false,
    this.discount,
  });

  factory CreditPackageModel.fromJson(Map<String, dynamic> json) {
    return CreditPackageModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      credits: json['credits'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      isPopular: json['isPopular'] ?? false,
      discount: json['discount']?.toDouble(),
    );
  }

  CreditPackage toEntity() {
    return CreditPackage(
      id: id,
      name: name,
      credits: credits,
      price: price,
      description: description,
      isPopular: isPopular,
      discount: discount,
    );
  }
}
