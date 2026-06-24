import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/source/remote/auth_repository.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository = AuthRepository();

  RegisterBloc() : super(RegisterState()) {
    on<AuthRegisterEvent>((event, emit) async {
      if (event.username.isNotEmpty &&
          event.password.isNotEmpty &&
          event.confirm == event.password &&
          event.username.endsWith("@gmail.com") &&
          event.password.length >= 6) {
        emit(state.copyWith(loading: true));
        bool register_response = await _authRepository.register(
          event.username,
          event.password,
        );
        emit(state.copyWith(loading: false));

        if (register_response) {
          emit(state.copyWith(isRegisterSuccess: true));
        } else {
          emit(state.copyWith(message: "Bu foydalanuvchi ro'yxatdan o'tgan"));
        }
      } else {
        if (event.username.isEmpty) {
          emit(state.copyWith(message: "Username kiriting"));
        } else if (event.password.isEmpty || event.confirm.isEmpty) {
          emit(state.copyWith(message: "Parollarni togri kiriting"));
        } else if (event.password != event.confirm) {
          emit(state.copyWith(message: "Parollar mos kelmayapti"));
        } else if (!event.username.endsWith("@gmail.com")) {
          emit(
            state.copyWith(message: "Username @gmail.com bilan tugashi kerak"),
          );
        } else {
          emit(
            state.copyWith(
              message: "Parolning uzunligi kamida 6ta belgi bo'lishi kerak",
            ),
          );
        }
      }
    });

    on<SignInWithGoogleEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      bool login_response = await _authRepository.signInWithGoogle();
      emit(state.copyWith(loading: false));

      if (login_response) {
        emit(state.copyWith(isRegisterSuccess: true));
      } else {
        emit(state.copyWith(message: "Xatolik yuz berdi"));
      }
    });
  }
}
