part of 'login_bloc.dart';

abstract class LoginEvent {}

class LogInEvent extends LoginEvent {
  final String username;
  final String password;

  LogInEvent(this.username, this.password);
}

class GoToRegisterEvent extends LoginEvent {}
class SignInWithGoogleEvent extends LoginEvent {}
