import 'package:customer_booking/core/error/dio_exeption.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<void, DioAppException>> login(String username, String password);
  Future<Either<void, DioAppException>> register(
    String username,
    String password,
    String email,
  );
}
