part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class CartStarted extends CartEvent {
  final String userId;

  CartStarted(this.userId);
}

class CartNoInternetConnection extends CartEvent {}

class CartAuth extends CartEvent {}

class CartDeleteProducts extends CartEvent {
  final String cartId;
  CartDeleteProducts(this.cartId);
}

class CartIncreaseCount extends CartEvent {
  final String cartItemId;

  CartIncreaseCount(this.cartItemId);
}

class CartDecreaseCount extends CartEvent {
  final String cartItemId;

  CartDecreaseCount(this.cartItemId);
}

class CartCheckOut extends CartEvent {
  final String userId;

  CartCheckOut(this.userId);
}
