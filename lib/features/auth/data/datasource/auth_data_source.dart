import 'dart:math';

import 'package:customer_booking/core/error/dio_exeption.dart';
import 'package:customer_booking/core/services/api/api_consumer.dart';
import 'package:customer_booking/features/auth/data/models/auth_model.dart';
import 'package:dartz/dartz.dart';

class AuthDataSource {
  final ApiConsumer apiConsumer;
  AuthDataSource(this.apiConsumer);

  Future<Either<DioAppException, AuthModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await apiConsumer.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final authModel = AuthModel.fromJson(response.data);
      return Right(authModel);
    } catch (e) {
      return Left(DioAppException(message: e.toString(), statusCode: -1));
    }
  }

  Future<Either<DioAppException, bool>> register(
    String username,
    String password,
    String email,
    String phoneNumber,
  ) async {
    try {
      await apiConsumer.post(
        '/auth/register',
        data: {
          'name': username,
          'password': password,
          'email': email,
          'phone': phoneNumber,
        },
      );
      return const Right(true);
    } catch (e) {
      return Left(DioAppException(message: e.toString(), statusCode: -1));
    }
  }
}
