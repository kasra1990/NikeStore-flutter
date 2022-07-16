part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}


class AuthInitialize extends AuthState{}
class AuthLoading extends AuthState {}

class SignInSuccess extends AuthState{
  final AuthDataModel authDataModel;
  SignInSuccess(this.authDataModel);
}

class SignUpSuccess extends AuthState{
  final AuthDataModel authDataModel;
  SignUpSuccess(this.authDataModel);
}

class AuthNoInternet extends AuthState{}

class AuthError extends AuthState{
  final String error;

  AuthError(this.error);
}


