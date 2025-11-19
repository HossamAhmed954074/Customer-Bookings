class AuthEntity {
    AuthEntity({
        required this.message,
        required this.token,
    });

    final String message;
    final String token;

    factory AuthEntity.fromJson(Map<String, dynamic> json){ 
        return AuthEntity(
            message: json["message"] ?? "",
            token: json["token"] ?? "",
        );
    }

}