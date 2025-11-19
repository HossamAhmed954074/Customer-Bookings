import 'package:customer_booking/core/error/dio_exeption.dart';
import 'package:customer_booking/features/auth/domain/entities/auth_entity.dart';
import 'package:customer_booking/features/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  Future<Either<DioAppException, AuthEntity>> call(
    String email,
    String password,
  ) async {
    try {
      return await repository.login(email, password);
    } catch (e) {
      return Future.value(
        Left(DioAppException(message: e.toString(), statusCode: -1)),
      );
    }
  }
}
