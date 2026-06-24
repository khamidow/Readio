part of 'login_bloc.dart';

class LoginState {
  final bool? isLoginSuccess;
  final bool? loading;
  final String? message;
  final bool? goToRegister;

  LoginState({this.isLoginSuccess, this.loading, this.message,this.goToRegister});

  LoginState copyWith({bool? isLoginSuccess, bool? loading, String? message,bool? goToRegister}) =>
      LoginState(
        isLoginSuccess: isLoginSuccess ?? false,
        loading: loading ?? false,
        message: message ?? "",
        goToRegister: goToRegister ?? false
      );
}
