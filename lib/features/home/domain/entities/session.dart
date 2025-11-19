import 'package:equatable/equatable.dart';

class Business extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final String? website;
  final List<String>? categories;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final double? distance; // Distance from user in meters

  const Business({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.website,
    this.categories,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.distance,
  });

  String get distanceText {
    if (distance == null) return '';
    if (distance! < 1000) {
      return '${distance!.toStringAsFixed(0)}m';
    }
    return '${(distance! / 1000).toStringAsFixed(1)}km';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    latitude,
    longitude,
    phone,
    email,
    website,
    categories,
    imageUrl,
    rating,
    reviewCount,
    distance,
  ];
}
