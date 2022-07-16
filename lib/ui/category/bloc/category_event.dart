part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class CategoryStarted extends CategoryEvent {
  final String userId;
  final String category;

  CategoryStarted(
      {required this.userId,
      required this.category});
}

class CategoryNoInternetConnection extends CategoryEvent{}
