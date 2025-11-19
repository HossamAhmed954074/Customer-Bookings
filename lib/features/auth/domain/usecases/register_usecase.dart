import 'package:customer_booking/core/error/dio_exeption.dart';
import 'package:customer_booking/features/auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);
  Future<Either<DioAppException, bool>> call(
    String username,
    String password,
    String email,
    String phoneNumber,
  ) async {
    try {
      return await repository.register(username, password, email, phoneNumber);
    } catch (e) {
      return Future.value(
        // ignore: void_checks
        Left(DioAppException(message: e.toString(), statusCode: -1)),
      );
    }
  }
}
