import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nike_flutter/data/model/AuthDataModel.dart';
import 'package:nike_flutter/data/repo/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository repository;
  AuthBloc(this.repository) : super(AuthInitialize()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignIn) {
        emit(AuthLoading());
        try {
          final response = await repository.singIn(event.email, event.password);
          emit(SignInSuccess(response));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      } else if (event is SignUp) {
        emit(AuthLoading());
        try {
          final response = await repository.singUp(event.email, event.password);
          emit(SignUpSuccess(response));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      } else if (event is AuthNoInternetConnection) {
        emit(AuthNoInternet());
      }
    });
  }
}
