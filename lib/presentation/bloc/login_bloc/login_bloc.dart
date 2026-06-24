import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/source/remote/auth_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();

  LoginBloc() : super(LoginState()) {
    on<LogInEvent>((event, emit) async {
      if (event.username.isNotEmpty && event.password.isNotEmpty) {
        emit(state.copyWith(loading: true));
        bool login_response = await _authRepository.login(
          event.username,
          event.password,
        );
        emit(state.copyWith(loading: false));

        if (login_response) {
          emit(state.copyWith(isLoginSuccess: true));
        } else {
          emit(state.copyWith(message: "Username yoki parol xato!"));
        }
      } else {
        emit(state.copyWith(message: "Barcha maydonlarni to'ldiring"));
      }
    });

    on<GoToRegisterEvent>((event, emit) {
      emit(state.copyWith(goToRegister: true));
    });

    on<SignInWithGoogleEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      bool login_response = await _authRepository.signInWithGoogle();
      emit(state.copyWith(loading: false));

      if (login_response) {
        emit(state.copyWith(isLoginSuccess: true));
      } else {
        emit(state.copyWith(message: "Xatolik yuz berdi"));
      }
    });
  }
}
