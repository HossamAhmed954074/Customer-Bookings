import 'package:bloc/bloc.dart';
import 'package:customer_booking/features/auth/domain/usecases/register_usecase.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUseCase) : super(RegisterInitial());
  final RegisterUseCase _registerUseCase;
  Future<void> register(
    String username,
    String password,
    String email,
    String phoneNumber,
  ) async {
    emit(RegisterLoading());
    final result = await _registerUseCase(
      username,
      password,
      email,
      phoneNumber,
    );
    result.fold(
      (failure) => emit(RegisterFailure(errorMessage: failure.message)),
      (isRegistered) => emit(RegisterSuccess(isRegistered: isRegistered)),
    );
  }
}
