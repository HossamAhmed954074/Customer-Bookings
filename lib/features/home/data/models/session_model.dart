import 'package:customer_booking/features/home/domain/entities/session.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    super.description,
    super.address,
    super.latitude,
    super.longitude,
    super.phone,
    super.email,
    super.website,
    super.categories,
    super.imageUrl,
    super.rating,
    super.reviewCount,
    super.distance,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    // Parse location coordinates
    double? lat;
    double? lng;
    if (json['location'] != null) {
      if (json['location']['coordinates'] != null &&
          json['location']['coordinates'] is List &&
          json['location']['coordinates'].length >= 2) {
        // GeoJSON format: [longitude, latitude]
        lng = json['location']['coordinates'][0]?.toDouble();
        lat = json['location']['coordinates'][1]?.toDouble();
      }
    }

    // Parse categories - handle both string and array
    List<String>? categories;
    if (json['type'] != null) {
      // Single type field
      categories = [json['type'].toString()];
    } else if (json['categories'] != null) {
      if (json['categories'] is List) {
        categories = (json['categories'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    // Get first image from images array
    String? imageUrl;
    if (json['images'] != null &&
        json['images'] is List &&
        (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0];
    } else if (json['imageUrl'] != null) {
      imageUrl = json['imageUrl'];
    } else if (json['image'] != null) {
      imageUrl = json['image'];
    }

    return BusinessModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      address: json['address'],
      latitude: lat,
      longitude: lng,
      phone: json['contactPhone'] ?? json['phone'],
      email: json['contactEmail'] ?? json['email'],
      website: json['website'],
      categories: categories,
      imageUrl: imageUrl,
      rating: json['rating']?.toDouble(),
      reviewCount: json['totalReviews'] ?? json['reviewCount'],
      distance: json['distance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'address': address,
      'location': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
      'phone': phone,
      'email': email,
      'website': website,
      'categories': categories,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'distance': distance,
    };
  }

  Business toEntity() {
    return Business(
      id: id,
      name: name,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      email: email,
      website: website,
      categories: categories,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      distance: distance,
    );
  }
}
