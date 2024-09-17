abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}




class LoginFormEvent extends AuthEvent {
  final String email;
  final String password;
  LoginFormEvent(this.email, this.password);
}