import 'package:customer_booking/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({required super.message, required super.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json["message"] ?? "",
      token: json["token"] ?? "",
    );
  }
}
