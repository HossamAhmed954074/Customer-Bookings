import 'package:customer_booking/core/error/dio_exeption.dart';
import 'package:customer_booking/features/auth/data/datasource/auth_data_source.dart';
import 'package:customer_booking/features/auth/data/models/auth_model.dart';
import 'package:customer_booking/features/auth/domain/entities/auth_entity.dart';
import 'package:customer_booking/features/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImplementation extends AuthRepository {
  final AuthDataSource authDataSource;
  AuthRepoImplementation(this.authDataSource);
  @override
  Future<Either<DioAppException, AuthModel>> login(
    String email,
    String password,
  ) {
    try {
      return authDataSource.login(email, password);
    } catch (e) {
      return Future.value(
        Left(DioAppException(message: e.toString(), statusCode: -1)),
      );
    }
  }

  @override
  Future<Either<DioAppException, bool>> register(
    String username,
    String password,
    String email,
    String phoneNumber,
  ) {
    try {
      return authDataSource.register(
        username,
        password,
        email,
        phoneNumber,
      );
    } catch (e) {
      return Future.value(
        Left(DioAppException(message: e.toString(), statusCode: -1)),
      );
    }
  }
}
