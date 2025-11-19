import 'package:customer_booking/core/error/dio_exeption.dart';
import 'package:customer_booking/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<DioAppException, AuthEntity>> login(
    String email,
    String password,
  );
  Future<Either<void, DioAppException>> register(
    String username,
    String password,
    String email,
  );
}
