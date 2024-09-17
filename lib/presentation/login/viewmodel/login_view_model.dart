import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginViewModel {
  final AuthBloc authBloc;

  LoginViewModel(this.authBloc);

  void login(String email, String password) {
    authBloc.add(LoginEvent(email, password));
  }

  void validateForm(String email, String password) {
    authBloc.add(LoginFormEvent(email, password));
  }
}