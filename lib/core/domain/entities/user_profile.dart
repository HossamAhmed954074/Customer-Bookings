import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final int credits;
  final String? phone;
  final String? avatarUrl;
  final String role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.credits,
    this.phone,
    this.avatarUrl,
    required this.role,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? credits,
    String? phone,
    String? avatarUrl,
    String? role,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      credits: credits ?? this.credits,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, name, email, credits, phone, avatarUrl, role];
}
