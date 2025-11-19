import 'package:customer_booking/core/domain/entities/user_profile.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final int credits;
  final String? phone;
  final String? avatarUrl;
  final String role;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.credits,
    this.phone,
    this.avatarUrl,
    required this.role,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      credits: json['credits'] ?? 0,
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'credits': credits,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'role': role,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      credits: credits,
      phone: phone,
      avatarUrl: avatarUrl,
      role: role,
    );
  }
}
