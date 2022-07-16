part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState{
  final List<ProductModel> products;

  CategorySuccess(this.products);
}

class CategoryConnection extends CategoryState{}

class CategoryError extends CategoryState{
  final String error;

  CategoryError(this.error);
}
