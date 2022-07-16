part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class ProductAddToCart extends ProductEvent{
final AddToCartModel model;

ProductAddToCart(this.model);
}

class ProductNoInternetConnection extends ProductEvent{}

