part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState{
  final HomeDataModel homeDataModel;
  HomeSuccess({required this.homeDataModel});
}

class HomeConnection extends HomeState{}

class HomeError extends HomeState{
  final String error;

  HomeError({required this.error});
}
