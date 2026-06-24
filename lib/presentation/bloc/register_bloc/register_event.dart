part of 'register_bloc.dart';

abstract class RegisterEvent {}

class AuthRegisterEvent extends RegisterEvent {
  final String username;
  final String password;
  final String confirm;

  AuthRegisterEvent(this.username, this.password, this.confirm);
}

class GoToLoginEvent extends RegisterEvent {}
class SignInWithGoogleEvent extends RegisterEvent {}
