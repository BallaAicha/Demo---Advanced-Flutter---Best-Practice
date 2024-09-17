abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String accessToken;
  final String refreshToken;
  AuthSuccess(this.accessToken, this.refreshToken);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class LoginFormState extends AuthState {
  final bool isUserNameValid;
  final bool isPasswordValid;
  final bool isFormValid;
  LoginFormState({
    required this.isUserNameValid,
    required this.isPasswordValid,
    required this.isFormValid,
  });
  @override
  List<Object?> get props => [isUserNameValid, isPasswordValid, isFormValid];
}

class AuthClearError extends AuthState {}