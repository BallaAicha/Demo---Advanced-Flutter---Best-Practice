import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc(this.loginUseCase) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase.execute(event.email, event.password);
      result.fold(
            (error) => emit(AuthFailure(error)),
            (response) {
          emit(AuthSuccess(response.accessToken, response.refreshToken));
          emit(AuthClearError());
        },
      );
    });

    on<LoginFormEvent>((event, emit) {
      _validateForm(event.email, event.password, emit);
    });
  }

  void _validateForm(String email, String password, Emitter<AuthState> emit) {
    final isUserNameValid = email.isNotEmpty;
    final isPasswordValid = password.isNotEmpty;
    final isFormValid = isUserNameValid && isPasswordValid;
    emit(LoginFormState(
      isUserNameValid: isUserNameValid,
      isPasswordValid: isPasswordValid,
      isFormValid: isFormValid,
    ));
  }
}