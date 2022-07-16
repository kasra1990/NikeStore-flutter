part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState{}


class ProductAddedSuccess extends ProductState{
  final MessageModel model;

  ProductAddedSuccess(this.model);
}

class ProductConnection extends ProductState{}

class ProductError extends ProductState{
  final String error;

  ProductError(this.error);
}
