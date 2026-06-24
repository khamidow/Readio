part of 'register_bloc.dart';

class RegisterState {
  final bool? isRegisterSuccess;
  final bool? loading;
  final String? message;
  final bool? goToLogin;

  RegisterState({this.isRegisterSuccess, this.loading, this.message,this.goToLogin});

  RegisterState copyWith({bool? isRegisterSuccess, bool? loading, String? message,bool? goToLogin}) =>
      RegisterState(
          isRegisterSuccess: isRegisterSuccess ?? false,
          loading: loading ?? false,
          message: message ?? "",
          goToLogin: goToLogin ?? false
      );
}
