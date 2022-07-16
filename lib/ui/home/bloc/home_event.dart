part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeStarted extends HomeEvent {}

class HomeNoInternetConnection extends HomeEvent {}
