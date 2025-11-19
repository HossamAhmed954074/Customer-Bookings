import 'package:bloc/bloc.dart';
import 'package:customer_booking/core/services/auth_storage_service.dart';
import 'package:customer_booking/features/auth/domain/entities/auth_entity.dart';
import 'package:customer_booking/features/auth/domain/usecases/login_usecase.dart';
import 'package:meta/meta.dart';

part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit(this._loginUseCase) : super(LogInInitial());
  final LoginUseCase _loginUseCase;
  Future<void> logIn(String email, String password) async {
    emit(LogInLoading());
    final result = await _loginUseCase(email, password);
    result.fold(
      (failure) => emit(LogInFailure(errorMessage: failure.message)),
      (authEntity) async {
        // Save token to local storage
        await AuthStorageService.saveToken(authEntity.token);
        emit(LogInSuccess(authEntity: authEntity));
      },
    );
  }
}
